// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veresiye_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VeresiyeModelAdapter extends TypeAdapter<VeresiyeModel> {
  @override
  final int typeId = 0;

  @override
  VeresiyeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VeresiyeModel(
      fields[0] as String,
      fields[1] as double,
      fields[2] as DateTime,
      fields[3] as bool,
      fields[4] as String,
      fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, VeresiyeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.musteriAdi)
      ..writeByte(1)
      ..write(obj.borcTutari)
      ..writeByte(2)
      ..write(obj.tarih)
      ..writeByte(3)
      ..write(obj.odendi)
      ..writeByte(4)
      ..write(obj.not)
      ..writeByte(5)
      ..write(obj.odenenTutar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VeresiyeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
