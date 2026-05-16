import 'dart:io';
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
      // No file path — skip
      if (filePath.isEmpty) {
        debugPrint("Přehrávání: žádný soubor.");
        return;
      }

      // On Android/iOS — check if file actually exists
      if (!kIsWeb) {
        final file = File(filePath);
        if (!await file.exists()) {
          debugPrint("Soubor neexistuje: $filePath");
          return;
        }
      }

      await _audioPlayer.play(DeviceFileSource(filePath));
    } catch (e) {
      debugPrint("Chyba při přehrávání: $e");
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
      final path = await _audioRecorder.stop();
      debugPrint("Recording stopped. Saved at: $path");
      return path;
    } catch (e) {
      debugPrint("Error stopping record: $e");
      return null;
    }
  }

  // Resource release
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
