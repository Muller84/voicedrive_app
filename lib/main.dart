import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/recording.dart';

void main() async {
  // 1. Musí být první, aby Flutter mohl inicializovat pluginy (mikrofon, úložiště)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializace Hive pro Flutter
  await Hive.initFlutter();

  // 3. Registrace automaticky generovaného adaptéru
  // ID typu v adaptéru musí odpovídat @HiveType(typeId: 0)
  Hive.registerAdapter(RecordingAdapter());

  // 4. Otevření boxu pro ukládání nahrávek
  // <Recording> říká Hive, že v tomto boxu budou jen me objekty
  await Hive.openBox<Recording>('recordings');

  // 5. Spuštění aplikace
  runApp(const VoiceDriveApp());
}

class VoiceDriveApp extends StatelessWidget {
  const VoiceDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoiceDrive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Nastavení tmavého režimu, aby ladilo s dashboardem
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
