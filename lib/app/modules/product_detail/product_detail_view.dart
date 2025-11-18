import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/product_detail/product_detail_controller.dart';
// --- IMPORT BARU ---
import 'package:intl/intl.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Detail Product'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          final product = controller.product.value;
          if (product == null) {
            return Center(child: Text('Produk tidak ditemukan.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              Container(
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
              SizedBox(height: 20),
              // Judul
              Text(
                product.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              // --- PERUBAHAN HARGA ---
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(product.price),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // --- AKHIR PERUBAHAN ---
              SizedBox(height: 8),
              // Kategori
              Chip(
                label: Text(product.category.capitalizeFirst ?? ''),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                labelStyle: TextStyle(color: theme.colorScheme.primary),
              ),
              SizedBox(height: 20),
              // Deskripsi
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                product.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 10),

              // --- Skenario Chained Request (Tidak berubah) ---
              Text(
                'Test Chained API Call',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '(Skenario: Ambil cart user 2, lalu ambil detail produk pertama di cart tsb)',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Ganti ke controller.runChainedAsync
                      child: Text('Run Async/Await'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          () {}, // Ganti ke controller.runChainedCallback
                      child: Text('Run .then()'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Obx(() {
                // Pastikan controller punya state ini jika masih dipakai
                // if (controller.isChainedLoading.value) {
                //   return Center(child: CircularProgressIndicator());
                // }
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Log:\n${""}', // Ganti ke controller.chainedLog.value
                    style: theme.textTheme.bodySmall,
                  ),
                );
              }),
            ],
          );
        }),
      ),
      // Tombol Add to Cart
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton.icon(
            icon: controller.isLoading.value
                ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(Icons.add_shopping_cart),
            label: Text(
                controller.isLoading.value ? 'MENAMBAHKAN...' : 'ADD TO CART'),
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (controller.product.value != null) {
                      controller.addToCart(controller.product.value!);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
