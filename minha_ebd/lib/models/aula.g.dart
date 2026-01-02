// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aula.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AulaAdapter extends TypeAdapter<Aula> {
  @override
  final typeId = 4;

  @override
  Aula read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aula(
      data: fields[0] as DateTime,
      professorKey: (fields[1] as num).toInt(),
      classeKey: (fields[2] as num).toInt(),
      presentes: (fields[3] as num).toInt(),
      ofertas: fields[4] == null ? 0.0 : (fields[4] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Aula obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.professorKey)
      ..writeByte(2)
      ..write(obj.classeKey)
      ..writeByte(3)
      ..write(obj.presentes)
      ..writeByte(4)
      ..write(obj.ofertas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AulaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
