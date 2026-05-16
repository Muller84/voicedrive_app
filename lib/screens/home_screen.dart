import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/speech_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recording.dart';
import 'package:flutter/foundation.dart';

/// HomeScreen – main UI of the VoiceDrive application.
/// Handles recording, speech-to-text, note listing and UI state.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // SERVICES
  final AudioService _audioService = AudioService(); // Audio recoreder service
  final SpeechService _speechService =
      SpeechService(); // Speech-to-text service

  // UI STATE VARIABLES
  bool _isRecording = false; // is recording in progress?
  bool _isTranscribing = false; // is speech to text in progress?
  bool _sortDescending = true; // sort the notes list

  // Text from transcription
  String _transcriptionText = "Tap the mic to start recording";

  @override
  void initState() {
    super.initState();
    _initSpeech(); // iniialization STT
  }

  /// Speech-to-text initialization
  void _initSpeech() async {
    bool available = await _speechService.initSpeech();
    if (available) {}
  }

  @override
  void dispose() {
    _audioService.dispose(); // End of audio recorder
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      // Main background with gradient
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
          ),
        ),

        // LayoutBuilder - desktop/phone
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // DESKTOP LAYOUT
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildPanel(
                      accentColor: Colors.blueAccent,
                      child: _buildNotesList(), // left side
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildPanel(
                      accentColor: _isRecording
                          ? Colors.redAccent
                          : Colors.purpleAccent,
                      child: _buildRecordingSection(), // right side
                    ),
                  ),
                ],
              );
            } else {
              // Phone layout
              return Column(
                children: [
                  const SizedBox(height: 20),
                  // Language idikator
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "EN",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildLogoArea(), // Logo area

                  Expanded(flex: 2, child: _buildTranscriptionBox()),
                  Expanded(
                    flex: 3,
                    child: _buildPanel(child: _buildNotesList()),
                  ),
                  _buildLargeMicButton(), // Button microphone
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Panel with rounded
  Widget _buildPanel({
    required Widget child,
    Color accentColor = Colors.blueAccent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(24), child: child),
    );
  }

  // Logo and text status
  Widget _buildLogoArea() {
    return Column(
      children: [
        Icon(
          Icons.graphic_eq_rounded,
          color: _isRecording ? Colors.redAccent : Colors.blueAccent,
          size: 42,
        ),
        const SizedBox(height: 8),
        Text(
          _isRecording
              ? "RECORDING ACTIVE"
              : _isTranscribing
              ? "TRANSCRIBING..."
              : "VoiceDrive",
          style: TextStyle(
            color: _isRecording
                ? Colors.redAccent
                : _isTranscribing
                ? Colors.orangeAccent
                : Colors.white70,
            fontSize: 12,
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Box with text transcription
  Widget _buildTranscriptionBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isRecording
            ? Colors.red.withValues(alpha: 0.05)
            : _isTranscribing
            ? Colors.orange.withValues(alpha: 0.05)
            : Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isRecording
              ? Colors.redAccent.withValues(alpha: 0.5)
              : _isTranscribing
              ? Colors.orangeAccent.withValues(alpha: 0.5)
              : Colors.white10,
          width: (_isRecording || _isTranscribing) ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          _transcriptionText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (_isRecording || _isTranscribing)
                ? Colors.white
                : Colors.white54,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  // List with notes (Hive)
  Widget _buildNotesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Button for sorting
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent List",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(
                  _sortDescending ? Icons.south_rounded : Icons.north_rounded,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _sortDescending = !_sortDescending);
                },
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              // Hive listener
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Recording>('recordings').listenable(),
                builder: (context, Box<Recording> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recordings yet",
                        style: TextStyle(color: Colors.white24),
                      ),
                    );
                  }

                  // Sorting notes
                  List<Recording> recordings = box.values.toList();
                  recordings.sort(
                    (a, b) => _sortDescending
                        ? b.createdAt.compareTo(a.createdAt)
                        : a.createdAt.compareTo(b.createdAt),
                  );

                  // ListView notes
                  return ListView.builder(
                    itemCount: recordings.length,
                    itemBuilder: (context, index) {
                      final rec = recordings[index];
                      final dateStr =
                          "${rec.createdAt.day}.${rec.createdAt.month}. ${rec.createdAt.hour}:${rec.createdAt.minute.toString().padLeft(2, '0')}";
                      Color tileColor = rec.createdAt.day == DateTime.now().day
                          ? Colors.greenAccent
                          : Colors.blueAccent;
                      return Dismissible(
                        key: Key(rec.id),
                        direction: DismissDirection.endToStart,

                        // Delete background
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        onDismissed: (direction) async => await rec.delete(),
                        child: _noteTile(
                          rec.transcript.isEmpty ? "No text" : rec.transcript,
                          dateStr,
                          tileColor,
                          rec.filePath,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // One note in list notes
  Widget _noteTile(String title, String tag, Color color, String filePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.waves_rounded, color: color, size: 18),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          tag,
          style: TextStyle(
            color: color.withValues(alpha: 0.8),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: filePath.isEmpty
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white54,
                ),
                onPressed: () => _audioService.playRecording(filePath),
              ),
      ),
    );
  }

  // Recording section – EN label, logo, transkripci and mic button
  Widget _buildRecordingSection() {
    return Stack(
      children: [
        // LANGUAGE TOGGLE
        Positioned(
          top: 40,
          right: 15,
          child: Text(
            "EN",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),

        // Main content aligned bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogoArea(),
              const SizedBox(height: 10),
              _buildTranscriptionBox(),
              const SizedBox(height: 10),
              _buildLargeMicButton(),
            ],
          ),
        ),
      ],
    );
  }

  // LARGE MIC BUTTON (start/stop recording)
  Widget _buildLargeMicButton() {
    // Disable button during transcribing phase
    final bool isDisabled = _isTranscribing;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () async {
                if (_isRecording) {
                  // STOP RECORDING
                  setState(() => _isRecording = false);
                  await _speechService.stopListening();

                  final box = Hive.box<Recording>('recordings');
                  await box.add(
                    Recording(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      filePath: '',
                      transcript: _transcriptionText == "Recording..."
                          ? ""
                          : _transcriptionText,
                      createdAt: DateTime.now(),
                      durationSeconds: 0.0,
                      category: "",
                    ),
                  );

                  setState(
                    () => _transcriptionText = "Tap the mic to start recording",
                  );
                } else {
                  // ── START RECORDING ──────────────────────────────────────
                  setState(() {
                    _isRecording = true;
                    _transcriptionText = "Recording...";
                  });

                  await _speechService.startListening((resultText) {
                    if (mounted && resultText.isNotEmpty) {
                      setState(() => _transcriptionText = resultText);
                    }
                  });
                }
              },

        // Design for button
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.orange.withValues(alpha: 0.6)
                : _isRecording
                ? Colors.redAccent
                : const Color(0xFF222222),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDisabled
                  ? Colors.orangeAccent
                  : _isRecording
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: isDisabled
                    ? Colors.orangeAccent.withValues(alpha: 0.4)
                    : _isRecording
                    ? Colors.redAccent.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            isDisabled
                ? Icons.hourglass_top_rounded
                : _isRecording
                ? Icons.stop_rounded
                : Icons.keyboard_voice_rounded,
            size: 38,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
