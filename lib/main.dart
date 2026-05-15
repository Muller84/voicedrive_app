import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/recording.dart';

void main() async {
  // 1. Must be called first to allow Flutter to initialise plugins (microphone, storage)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialise Hive for Flutter
  await Hive.initFlutter();

  // 3. Register the automatically generated adapter
  // The typeId must match @HiveType(typeId: 0)
  Hive.registerAdapter(RecordingAdapter());

  // 4. Open the Hive box for storing recordings
  // <Recording> ensures that only Recording objects are stored
  await Hive.openBox<Recording>('recordings');

  // 5. Launch the application
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
        // Setting dark mode to match my dashboard
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
