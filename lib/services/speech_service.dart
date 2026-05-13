import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  // Inicializace STT
  Future<bool> initSpeech() async {
    _isAvailable = await _speech.initialize(
      onError: (val) => print('Speech Error: $val'),
      onStatus: (val) => print('Speech Status: $val'),
    );
    return _isAvailable;
  }

  // Získání nejlepšího jazyka podle systému + fallback na en_GB
  Future<String> _getBestLocale() async {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final locales = await _speech.locales();

    // Najdi první locale, které začíná stejným jazykovým kódem (cs, en, atd.)
    var match = locales.where(
      (l) => l.localeId.startsWith(systemLocale.languageCode),
    );

    final selected = match.isNotEmpty ? match.first.localeId : 'en_GB';

    print("Using STT locale: $selected");
    return selected;
  }

  // Spuštění naslouchání
  // V speech_service.dart
  Future<void> startListening(
    Function(String) onResult, {
    String? localeId,
  }) async {
    if (!_isAvailable) return;

    // Pokud localeId nepřijde, použije se automatika nebo fallback
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

  // Zastavení naslouchání
  Future<void> stopListening() async {
    await _speech.stop();
  }
}
