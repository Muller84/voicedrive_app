import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/speech_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recording.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();
  final SpeechService _speechService = SpeechService();

  bool _isRecording = false;
  bool _sortDescending = true; // default

  String _transcriptionText = "Tap the mic to start recording";
  String _selectedLocale = 'cs-CZ';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechService.initSpeech();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  // --- POMOCNÁ METODA PRO TLAČÍTKA JAZYKA ---
  Widget _languageChip(String label, String code) {
    bool isSelected = _selectedLocale == code;
    return GestureDetector(
      onTap: () => setState(() => _selectedLocale = code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.white10,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white24,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildPanel(
                      accentColor: Colors.blueAccent,
                      child: _buildNotesList(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildPanel(
                      accentColor: _isRecording
                          ? Colors.redAccent
                          : Colors.purpleAccent,
                      child: _buildRecordingSection(),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  // Přepínač pro mobil v jedné řadě, zarovnaný doprava
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _languageChip("CZ", "cs-CZ"),
                        const SizedBox(width: 8),
                        _languageChip("EN", "en-US"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLogoArea(),
                  Expanded(flex: 2, child: _buildTranscriptionBox()),
                  Expanded(
                    flex: 3,
                    child: _buildPanel(child: _buildNotesList()),
                  ),
                  _buildLargeMicButton(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

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
          _isRecording ? "RECORDING ACTIVE" : "VoiceDrive",
          style: TextStyle(
            color: _isRecording ? Colors.redAccent : Colors.white70,
            fontSize: 12,
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptionBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isRecording
            ? Colors.red.withValues(alpha: 0.05)
            : Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isRecording
              ? Colors.redAccent.withValues(alpha: 0.5)
              : Colors.white10,
          width: _isRecording ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          _isRecording && _transcriptionText.isEmpty
              ? "Listening..."
              : _transcriptionText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _isRecording ? Colors.white : Colors.white54,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  setState(() {
                    _sortDescending = !_sortDescending;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
                  List<Recording> recordings = box.values.toList();

                  recordings.sort((a, b) {
                    if (_sortDescending) {
                      return b.createdAt.compareTo(
                        a.createdAt,
                      ); // nejnovější nahoře
                    } else {
                      return a.createdAt.compareTo(
                        b.createdAt,
                      ); // nejstarší nahoře
                    }
                  });

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
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        onDismissed: (direction) {
                          // Smazání z databáze Hive
                          box.deleteAt(recordings.length - 1 - index);
                        },
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
        trailing: IconButton(
          icon: const Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.white54,
          ),
          onPressed: () {
            // Teď už proměnná filePath existuje!
            _audioService.playRecording(filePath);
          },
        ),
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Stack(
      children: [
        // PŘEPÍNAČE V ROHU
        Positioned(
          top: 15,
          right: 15,
          child: Row(
            children: [
              _languageChip("CZ", "cs-CZ"),
              const SizedBox(width: 6),
              _languageChip("EN", "en-US"),
            ],
          ),
        ),
        // HLAVNÍ OBSAH UPROSTŘED
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildLargeMicButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () async {
          if (_isRecording) {
            // 1. nastavim stav na false, aby ignoroval dalsi text
            setState(() {
              _isRecording = false;
            });
            // 2. zastavim sluzby
            final path = await _audioService.stopRecording();
            await _speechService.stopListening();

            // 3. Kod pro ulozeni do Hive
            if (path != null) {
              final box = Hive.box<Recording>('recordings');
              await box.add(
                Recording(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  filePath: path,
                  transcript: _transcriptionText,
                  createdAt: DateTime.now(),
                  durationSeconds: 0.0,
                  category: "",
                ),
              );
            }
            await Future.delayed(const Duration(milliseconds: 100));

            // 4. Resetuji text pole
            setState(() {
              _transcriptionText = "Tap the mic to start recording";
            });
          } else {
            // Start nahravani
            await _audioService.startRecording();
            setState(() {
              _isRecording = true;
              _transcriptionText = "";
            });

            await _speechService.startListening((resultText) {
              // POJISTKA: text v poli aktualizuji jen pokud nahravani stale bezi
              if (_isRecording) {
                setState(() {
                  _transcriptionText = resultText;
                });
              }
            }, localeId: _selectedLocale);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _isRecording ? Colors.redAccent : const Color(0xFF222222),
            shape: BoxShape.circle,
            // --- TADY JE TO OHRANIČENÍ ---
            border: Border.all(
              color: _isRecording
                  ? Colors.white
                  : Colors.white.withValues(
                      alpha: 0.15,
                    ), // Viditelné ohraničení v klidu
              width: 4, // Tloušťka linky
            ),
            boxShadow: [
              BoxShadow(
                color: _isRecording
                    ? Colors.redAccent.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            _isRecording ? Icons.stop_rounded : Icons.keyboard_voice_rounded,
            size: 38,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
