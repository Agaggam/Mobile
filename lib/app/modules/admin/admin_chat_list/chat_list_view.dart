import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_list_controller.dart';

class AdminChatListView extends GetView<AdminChatListController> {
  const AdminChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Chat User',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chatList.isEmpty) {
          return const Center(
            child: Text('Belum ada chat yang masuk.'),
          );
        }

        return ListView.builder(
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            final profile = controller.chatList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    profile.email?[0].toUpperCase() ?? 'U',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                title: Text(
                  profile.email ?? 'User (ID: ${profile.id})',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Klik untuk melihat percakapan...'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => controller.goToChatDetail(profile),
              ),
            );
          },
        );
      }),
    );
  }
}
