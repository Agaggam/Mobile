import 'package:hive/hive.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      quantity: 1,
    );
  }

  Map<String, dynamic> toJsonForProduct() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': '',
      'category': '',
      'image': image,
    };
  }
}
