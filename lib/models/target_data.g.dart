// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetDataAdapter extends TypeAdapter<TargetData> {
  @override
  final int typeId = 0;

  @override
  TargetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetData(
      uid: fields[0] as String?,
      redLine: fields[2] as String?,
      title: fields[1] as String?,
      reward: fields[3] as String?,
      punishment: fields[4] as String?,
      isDone: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TargetData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.redLine)
      ..writeByte(3)
      ..write(obj.reward)
      ..writeByte(4)
      ..write(obj.punishment)
      ..writeByte(5)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
