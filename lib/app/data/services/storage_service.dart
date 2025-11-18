import 'dart:io';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:image_picker/image_picker.dart'; // (Perlu ditambah di pubspec jika belum ada)

class StorageService extends GetxService {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // Nama bucket di Supabase Storage
  static const String _bucketName = 'product-images';

  // Fungsi untuk upload gambar
  // Mengembalikan URL publik gambar yang berhasil diupload
  Future<String?> uploadProductImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'products/$fileName';

      // Upload file
      await _supabase.client.storage.from(_bucketName).upload(path, imageFile);

      // Dapatkan URL publik
      final imageUrl =
          _supabase.client.storage.from(_bucketName).getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
