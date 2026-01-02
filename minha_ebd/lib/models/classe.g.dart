// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClasseAdapter extends TypeAdapter<Classe> {
  @override
  final typeId = 3;

  @override
  Classe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Classe(
      nome: fields[0] as String,
      faixaEtaria: fields[1] as String,
      tipo: fields[2] as String,
      ativa: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Classe obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.faixaEtaria)
      ..writeByte(2)
      ..write(obj.tipo)
      ..writeByte(3)
      ..write(obj.ativa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClasseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
