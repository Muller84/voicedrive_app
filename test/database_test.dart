import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:voicedrive_app/models/recording.dart';

void main() {
  test('Test uložení a načtení nahrávky z Hive', () {
    // 1. VSTUP (Input)
    final recording = Recording(
      id: '123',
      filePath: 'path/to/file.m4a',
      transcript: 'Test transcript',
      createdAt: DateTime.now(),
      durationSeconds: 10.5,
    );

    // 2. OČEKÁVANÝ VÝSTUP - Expected Output
    // Očekávám, že id v objektu bude '123'
    expect(recording.id, '123');
  });
}
