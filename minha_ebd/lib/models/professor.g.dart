// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfessorAdapter extends TypeAdapter<Professor> {
  @override
  final typeId = 2;

  @override
  Professor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Professor(
      nome: fields[0] as String,
      sexo: fields[1] as String,
      telefone: fields[2] as String,
      ativo: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Professor obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.sexo)
      ..writeByte(2)
      ..write(obj.telefone)
      ..writeByte(3)
      ..write(obj.ativo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
