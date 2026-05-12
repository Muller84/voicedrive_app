part of 'recording.dart';

// **************************************************************************
// TypeAdapterGenerator, automatically generated translator for object and database Hive.
// **************************************************************************

class RecordingAdapter extends TypeAdapter<Recording> {
  @override
  final int typeId = 0;

  @override
  // Read binary data from Hive folder and convert it to a Recording object, using map fields.
  // Nacteni Recording z Hive. V Hive se data ukladaji v binarni podobe, tento kod je prevede zpet do objektu.
  Recording read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recording(
      id: fields[0] as String,
      filePath: fields[1] as String,
      transcript: fields[2] as String,
      createdAt: fields[3] as DateTime,
      durationSeconds: fields[4] as double,
      category: fields[5] as String?,
    );
  }

  @override
  // Take a Recording object and write his values to Hive database in binary format.
  // Ulozeni Recording do Hive. V Hive se data ukladaji v binarni podobe, tento kod prevede objekt do binarni podoby.
  void write(BinaryWriter writer, Recording obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.transcript)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.durationSeconds)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  // Identify the type in Hive database, has to be unique for each class.
  // hashCode enables Hive to compare adapters.
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
