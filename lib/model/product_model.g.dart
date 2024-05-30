// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 1;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products()..cart = (fields[0] as List?)?.cast<Products>();
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.cart);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
