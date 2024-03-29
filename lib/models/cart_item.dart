// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({
    @required this.id,
    @required this.productId,
    @required this.storeId,
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.image,
  });

  String id;
  String productId;
  String storeId;
  String name;
  double price;
  int quantity;
  String image;

  factory CartItem.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    return CartItem(
      id: documentId,
      productId:
          data['productId'] is String ? data['productId']?.toString() : '',
      storeId: data['storeId'] is String ? data['storeId']?.toString() : '',
      name: data['name'] is String ? data['name']?.toString() : '',
      price: data['price'] is num ? data['price']?.toDouble() as double : 00.00,
      quantity: data['quantity'] is num ? data['quantity']?.toInt() as int : 0,
      image: data['image'] is String ? data['image']?.toString() : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': id is String ? id?.toString() : '',
      'storeId': storeId is String ? storeId?.toString() : '',
      'name': name is String ? name?.toString() : '',
      'quantity': quantity is num ? quantity?.toInt() : 0,
      'price': price is num ? price?.toDouble() : 00.00,
    };
  }

  @override
  int get hashCode =>
      hashValues(id, productId, storeId, name, price, quantity, image);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Object otherCartItem = other;
    return otherCartItem is CartItem &&
        id == otherCartItem.id &&
        productId == otherCartItem.productId &&
        storeId == otherCartItem.storeId &&
        name == otherCartItem.name &&
        price == otherCartItem.price &&
        quantity == otherCartItem.quantity &&
        image == otherCartItem.image;
  }

  @override
  String toString() =>
      'id: $id, productId: $productId, storeId: $storeId, name: $name, price: $price, quantity: $quantity, image: $image';
}
