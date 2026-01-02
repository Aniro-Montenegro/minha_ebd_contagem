// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superintendente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuperintendenteAdapter extends TypeAdapter<Superintendente> {
  @override
  final typeId = 1;

  @override
  Superintendente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Superintendente(nome: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, Superintendente obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.nome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperintendenteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
