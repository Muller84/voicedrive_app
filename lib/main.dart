import 'package:flutter/material.dart'; // material design package for building the UI
import 'screens/home_screen.dart';

// Start app, flutter spusti widget VoiceDriveApp, which is the root of the application.
void main() {
  runApp(const VoiceDriveApp());
}

// VoiceDriveApp nemeni stav (pro konfiguraci, theme, routing)
class VoiceDriveApp extends StatelessWidget {
  const VoiceDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    // hlavni kontejner app (obsahuje theme, navigation, home screen)
    return MaterialApp(
      title: 'VoiceDrive',
      debugShowCheckedModeBanner: false, // skryje debug banner v rohu
      // definuje barvy a styl app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // pouziti Material Design 3 (novy design system)
      ),
      // po spusteni app se zobrazi HomeScreen widget
      home: const HomeScreen(),
    );
  }
}
