import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  Future<bool> initSpeech() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (val) => debugPrint(
          '### STT ERROR: ${val.errorMsg} | permanent: ${val.permanent}',
        ),
        onStatus: (val) => debugPrint('### STT STATUS: $val'),
        debugLogging: true, // ← přidej toto!
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
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final locales = await _speech.locales();

    debugPrint('System locale: ${systemLocale.languageCode}');
    debugPrint(
      'Available STT locales: ${locales.map((l) => l.localeId).toList()}',
    );

    // Normalizace: porovnáváme jen language code (cs, en...)
    // a ignorujeme podtržítko vs pomlčka rozdíly
    final langCode = systemLocale.languageCode.toLowerCase();

    var match = locales.where(
      (l) => l.localeId.toLowerCase().replaceAll('-', '_').startsWith(langCode),
    );

    final selected = match.isNotEmpty ? match.first.localeId : 'en_GB';
    debugPrint('Using STT locale: $selected');
    return selected;
  }

  Future<void> startListening(
    Function(String) onResult, {
    String? localeId,
  }) async {
    if (!_isAvailable) {
      debugPrint('STT not available, trying re-init...');
      await initSpeech();
      if (!_isAvailable) return;
    }

    // Zastav případné předchozí naslouchání
    if (_speech.isListening) {
      await _speech.stop();
      await Future.delayed(const Duration(milliseconds: 200));
    }

    final finalLocale = localeId ?? await _getBestLocale();

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
        // dictation nefunguje spolehlivě na Androidu
        // Použiji confirmation nebo deviceDefault
        listenMode: kIsWeb ? ListenMode.dictation : ListenMode.confirmation,
        cancelOnError: true,
        autoPunctuation: true,
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isAvailable;
}
