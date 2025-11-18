import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/models/message_model.dart';

class LocalStorageService extends GetxService {
  late final Box<CartItem> _cartBox;
  late final Box<Message> _chatBox;

  Future<LocalStorageService> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(CartItemAdapter().typeId)) {
      Hive.registerAdapter(CartItemAdapter());
    }

    _cartBox = await Hive.openBox<CartItem>('shopping_cart');

    print('Hive (LocalStorageService) initialized.');
    return this;
  }

  Box<CartItem> get cartBox => _cartBox;
  Box<Message> get chatBox => _chatBox;
}
