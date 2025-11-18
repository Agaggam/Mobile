import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class AdminHomeController extends GetxController {
  final SupabaseService _supabase = Get.find();

  void logout() async {
    await _supabase.client.auth.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
