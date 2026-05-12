import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Inicializace služby pro nahrávání
  final AudioService _audioService = AudioService();

  // Proměnná, která drží informaci, zda se zrovna nahrává
  bool _isRecording = false;

  @override
  void dispose() {
    _audioService.dispose(); // Správné uvolnění mikrofonu při zavření appky
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VoiceDrive")),
      body: const Center(
        child: Text("No recordings yet", style: TextStyle(fontSize: 18)),
      ),
      floatingActionButton: FloatingActionButton(
        // Dynamická změna barvy: červená při nahrávání, modrá v klidu
        backgroundColor: _isRecording ? Colors.red : Colors.blue,
        onPressed: () async {
          if (_isRecording) {
            // 1. Zastavit nahrávání
            String? path = await _audioService.stopRecording();

            // 2. Aktualizovat stav UI
            setState(() {
              _isRecording = false;
            });

            if (path != null) {
              print("Ready to save to Hive: $path");
            }
          } else {
            // 1. Spustit nahrávání
            await _audioService.startRecording();

            // 2. Aktualizovat stav UI
            setState(() {
              _isRecording = true;
            });
          }
        },
        // Dynamická změna ikonky
        child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
      ),
    );
  }
}
