// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'igreja.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IgrejaAdapter extends TypeAdapter<Igreja> {
  @override
  final typeId = 0;

  @override
  Igreja read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Igreja(nome: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, Igreja obj) {
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
      other is IgrejaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
