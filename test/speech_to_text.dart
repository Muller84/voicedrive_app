import 'package:flutter_test/flutter_test.dart';

// Definuji prázdnou třídu, aby kód šel spustit, ale nefungoval
class SpeechService {
  Future<String> convertAudioToText(String path) async {
    // v TDD začínu tím, že funkce nevrací to, co chci
    return "";
  }
}

void main() {
  test('TDD: Převod audia na text by měl vrátit rozpoznaná slova', () async {
    final service = SpeechService();

    // Simuluji volání s cestou k souboru
    final result = await service.convertAudioToText('test_audio.wav');

    // Očekávám, že se vrátí "Ahoj", ale funkce vrátí prázdný text
    // TENTO TEST SCHVÁLNĚ SELŽE
    expect(result, "Ahoj");
  });
}
