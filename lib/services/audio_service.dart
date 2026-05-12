import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'
    show
        kIsWeb; // This import for checking if the app is running on Web or Mobile

class AudioService {
  final AudioRecorder _audioRecorder = AudioRecorder();

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        String filePath = '';

        if (!kIsWeb) {
          // Code for mobile.
          final directory = await getApplicationDocumentsDirectory();
          filePath =
              '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        } else {
          // Code for Web: Leave path empty, Chrome will create a Blob URL
          filePath = '';
          print("Running on Web - path is handled by browser");
        }

        const config = RecordConfig();
        await _audioRecorder.start(config, path: filePath);

        print("Recording started. Path target: $filePath");
      }
    } catch (e) {
      print("Error starting record: $e");
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

  void dispose() => _audioRecorder.dispose();
}
