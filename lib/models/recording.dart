import 'package:hive/hive.dart';

// Define object Recording (rikam Hive "Takhle vypada Recording.")

// Connect model with adapter. If not build_runner will be red.
part 'recording.g.dart';

// This object has type ID 0, use for them RecordingAdapter.
// key 0, value id
@HiveType(typeId: 0)
class Recording extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  final String transcript;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final double durationSeconds;

  @HiveField(5)
  final String? category;

  Recording({
    required this.id,
    required this.filePath,
    required this.transcript,
    required this.createdAt,
    required this.durationSeconds,
    this.category,
  });
}
