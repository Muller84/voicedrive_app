import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Play a saved recording
  Future<void> playRecording(String filePath) async {
    try {
      // On Android - play directly from a file on the device
      await _audioPlayer.play(DeviceFileSource(filePath));
    } catch (e) {
      print("Chyba při přehrávání: $e");
    }
  }

  // Start recording
  Future<void> startRecording() async {
    try {
      debugPrint("Kontrola oprávnění...");
      final hasPermission = await _audioRecorder.hasPermission();

      if (hasPermission) {
        // If recording is already running, stop it
        if (await _audioRecorder.isRecording()) {
          debugPrint("Nahrávání už běží, zastavuji staré...");
          await _audioRecorder.stop();
        }

        String filePath = '';
        // PLATFORM-SPECIFIC LOGIKA
        // Android - save to the real file system
        // Web - path_provider DOES NOT EXIST - need to skip
        if (!kIsWeb) {
          final directory = await getApplicationDocumentsDirectory();
          // Create a path to the .m4a file on the phone
          filePath =
              '${directory.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }

        // Recording configuration
        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 16000,
          numChannels: 1,
        );

        debugPrint("Startuji rekordér do cesty: $filePath");

        // Logic for web
        // On the website, the path is ignored - the plugin creates a Blob URL
        await _audioRecorder.start(config, path: filePath);
        debugPrint("Rekordér úspěšně spuštěn.");
      } else {
        debugPrint("Uživatel zamítl přístup k mikrofonu.");
      }
    } catch (e) {
      debugPrint("KRITICKÁ CHYBA při startu: $e");
    }
  }

  // Stop recording
  Future<String?> stopRecording() async {
    try {
      // Android - returns the path to the .m4a file
      // Web - Blob URL
      final path = await _audioRecorder.stop();
      print("Recording stopped. Saved at: $path");
      return path;
    } catch (e) {
      print("Error stopping record: $e");
      return null;
    }
  }

  // Resource release
  // Ends recording and closes native audio channels.
  // Frees the player from memory usage.
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
