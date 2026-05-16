import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;
  bool _shouldBeListening = false; // sleduje jestli má STT běžet
  Function(String)? _lastCallback; // uloží callback pro restart

  Future<bool> initSpeech() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (val) => debugPrint(
          '### STT ERROR: ${val.errorMsg} | permanent: ${val.permanent}',
        ),
        onStatus: (val) {
          debugPrint('### STT STATUS: $val');
          // AUTO-RESTART: když se STT zastaví ale chci naslouchat
          if ((val == 'notListening' || val == 'done') && _shouldBeListening) {
            debugPrint('### STT AUTO-RESTART');
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_shouldBeListening && _lastCallback != null) {
                _startListeningInternal(_lastCallback!);
              }
            });
          }
        },
        debugLogging: true,
      );
      debugPrint('### STT AVAILABLE: $_isAvailable');
      if (_isAvailable) {
        final locales = await _speech.locales();
        debugPrint('### STT LOCALES COUNT: ${locales.length}');
      }
    } catch (e) {
      debugPrint('### STT INIT EXCEPTION: $e');
    }
    return _isAvailable;
  }

  Future<String> _getBestLocale() async {
    return 'en_GB';
  }

  Future<void> startListening(Function(String) onResult) async {
    _shouldBeListening = true; // nastav flag!
    _lastCallback = onResult; // ulož callback!
    await _startListeningInternal(onResult);
  }

  Future<void> _startListeningInternal(Function(String) onResult) async {
    if (!_isAvailable) {
      await initSpeech();
      if (!_isAvailable) return;
    }

    if (_speech.isListening) {
      await _speech.stop();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    final finalLocale = await _getBestLocale();

    await _speech.listen(
      onResult: (val) {
        debugPrint(
          'Recognized: ${val.recognizedWords} (final: ${val.finalResult})',
        );
        onResult(val.recognizedWords);
      },
      localeId: finalLocale,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        autoPunctuation: true,
      ),
    );
  }

  Future<void> stopListening() async {
    _shouldBeListening = false; // zastav auto-restart
    _lastCallback = null;
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isAvailable;
}
