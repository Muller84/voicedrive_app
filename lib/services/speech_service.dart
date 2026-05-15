import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  // Variables
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  // Initialise the Speech-to-Text engine
  Future<bool> initSpeech() async {
    _isAvailable = await _speech.initialize(
      onError: (val) => print('Speech Error: $val'),
      onStatus: (val) => print('Speech Status: $val'),
    );
    return _isAvailable;
  }

  // Determine the best locale based on system language, with fallback to en_GB
  Future<String> _getBestLocale() async {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final locales = await _speech.locales();

    // Find the first locale that matches the system language code (cs, en, etc.)
    var match = locales.where(
      (l) => l.localeId.startsWith(systemLocale.languageCode),
    );

    final selected = match.isNotEmpty ? match.first.localeId : 'en_GB';

    print("Using STT locale: $selected");
    return selected;
  }

  // Start listening for speech input
  Future<void> startListening(
    Function(String) onResult, {
    String? localeId,
  }) async {
    if (!_isAvailable) return;

    // If no locale is provided, use automatic selection or fallback
    final finalLocale = localeId ?? await _getBestLocale();

    _speech.listen(
      onResult: (val) => onResult(val.recognizedWords),
      localeId: finalLocale, // Použijeme ten vybraný
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
  }
}
