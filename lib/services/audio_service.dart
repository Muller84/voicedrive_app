import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playRecording(String filePath) async {
    try {
      // Source může být DeviceFile, protože nahrávka je uložená v telefonu
      await _audioPlayer.play(DeviceFileSource(filePath));
    } catch (e) {
      print("Chyba při přehrávání: $e");
    }
  }

  Future<void> startRecording() async {
    try {
      debugPrint("Kontrola oprávnění...");
      final hasPermission = await _audioRecorder.hasPermission();

      if (hasPermission) {
        // Kontrola, jestli už nenahrávám
        if (await _audioRecorder.isRecording()) {
          debugPrint("Nahrávání už běží, zastavuji staré...");
          await _audioRecorder.stop();
        }

        String filePath = '';
        if (!kIsWeb) {
          final directory = await getApplicationDocumentsDirectory();
          filePath =
              '${directory.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }

        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 16000,
          numChannels: 1,
        );

        debugPrint("Startuji rekordér do cesty: $filePath");
        await _audioRecorder.start(config, path: filePath);
        debugPrint("Rekordér úspěšně spuštěn.");
      } else {
        debugPrint("Uživatel zamítl přístup k mikrofonu.");
      }
    } catch (e) {
      debugPrint("KRITICKÁ CHYBA při startu: $e");
    }
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      print("Recording stopped. Saved at: $path");
      return path;
    } catch (e) {
      print("Error stopping record: $e");
      return null;
    }
  }

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
