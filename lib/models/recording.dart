import 'package:hive/hive.dart';

// Added during feature/recording development
// Tento řádek bude červený, dokud build_runner neskončí úspěšně
part 'recording.g.dart';

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
