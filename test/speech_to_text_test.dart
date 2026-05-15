import 'package:flutter_test/flutter_test.dart';

// Temporary placeholder implementation used during TDD
class SpeechService {
  Future<String> convertAudioToText(String path) async {
    // Initial implementation intentionally returns empty output
    return "";
  }
}

void main() {
  test(
    'TDD: Audio-to-text conversion should return recognised words',
    () async {
      final service = SpeechService();

      // Simulated audio input
      final result = await service.convertAudioToText('test_audio.wav');

      // Expected transcription output
      // This test intentionally fails during the Red phase of TDD
      expect(result, "Hello");
    },
  );
}
