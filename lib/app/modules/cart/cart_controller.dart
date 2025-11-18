import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  Box<CartItem> get _cartBox => _localStorage.cartBox;

  // --- PERBAIKAN STATE ---
  // Kita tidak perlu state '.obs' di sini,
  // karena CartView akan me-listen ke Hive Box secara langsung.
  // --- AKHIR PERBAIKAN ---

  // Method untuk menambah produk ke keranjang
  void addToCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;
      existingItem.quantity += 1;
      existingItem.save(); // Simpan perubahan ke Hive
    } else {
      final newItem = CartItem.fromProduct(product);
      _cartBox.put(product.id, newItem); // Tambah item baru ke Hive
    }

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${product.title} ditambahkan ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // Kita panggil update() agar getter (totalPrice/totalItemCount)
    // yang ada di dalam Obx() ikut diperbarui
    update();
  }

  // Method untuk menghapus produk dari keranjang
  void removeFromCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;
      if (existingItem.quantity > 1) {
        existingItem.quantity -= 1;
        existingItem.save();
      } else {
        _cartBox.delete(product.id);
      }
      // Panggil update() untuk memperbarui UI
      update();
    }
  }

  // --- COMPUTED PROPERTY (Getter) ---
  // Ini akan dipanggil oleh Obx() di CartView
  double get totalPrice {
    return _cartBox.values
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, price) => prev + price);
  }

  int get totalItemCount {
    return _cartBox.values.fold(0, (prev, item) => prev + item.quantity);
  }
}
