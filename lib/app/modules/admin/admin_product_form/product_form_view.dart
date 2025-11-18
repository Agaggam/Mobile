import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_form_controller.dart';

class AdminProductFormView extends GetView<AdminProductFormController> {
  const AdminProductFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            controller.productToEdit == null ? 'Tambah Produk' : 'Edit Produk'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN GAMBAR ---
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _buildImagePreview(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(child: Text('Tap untuk ganti gambar')),
                const SizedBox(height: 24),

                // --- NAMA PRODUK ---
                TextFormField(
                  controller: controller.titleC,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                // --- HARGA ---
                TextFormField(
                  controller: controller.priceC,
                  decoration: const InputDecoration(
                    labelText: 'Harga (Rp)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Harga wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                // --- KATEGORI DROPDOWN ---
                DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  hint: const Text('Pilih Kategori'),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: controller.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategoryId.value = value;
                  },
                  validator: (value) {
                    // Validasi hanya jika ini produk baru
                    if (controller.productToEdit == null && value == null) {
                      return 'Kategori wajib dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- DESKRIPSI ---
                TextFormField(
                  controller: controller.descriptionC,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Deskripsi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 32),

                // --- TOMBOL SIMPAN ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('SIMPAN PRODUK'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImagePreview() {
    if (controller.selectedImage.value != null) {
      return Image.file(controller.selectedImage.value!, fit: BoxFit.cover);
    } else if (controller.existingImageUrl.value.isNotEmpty) {
      return Image.network(controller.existingImageUrl.value,
          fit: BoxFit.cover);
    } else {
      return const Icon(Icons.add_a_photo, size: 50, color: Colors.grey);
    }
  }
}
