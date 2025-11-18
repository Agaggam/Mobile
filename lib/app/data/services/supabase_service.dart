import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  User? get currentUser => client.auth.currentUser;

  Future<SupabaseService> init() async {
    try {
      await dotenv.load(fileName: ".env");

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception("Kredensial Supabase tidak ditemukan di .env");
      }
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      client = Supabase.instance.client;
      print('Supabase terinisialisasi!');
    } catch (e) {
      print('!!!!!!!!!!!!!! ERROR INISIALISASI SUPABASE !!!!!!!!!!!!!!');
      print('Error: $e');
      print('Pastikan .env ada di root dan pubspec.yaml assets sudah benar.');
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      rethrow;
    }
    return this;
  }
}
