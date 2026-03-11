import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VoiceDrive")),
      body: const Center(
        child: Text("No recordings yet", style: TextStyle(fontSize: 18)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // zde později spustím recording!
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
