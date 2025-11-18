import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_detail_controller.dart';

class AdminChatDetailView extends GetView<AdminChatDetailController> {
  const AdminChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat: ${controller.targetUser.email ?? 'User'}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 1. Area Chat (Daftar Pesan)
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text('Belum ada percakapan.'),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                controller.scrollToBottom();
              });

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  // Cek apakah 'isMe' (Admin)
                  final isMe = message.senderId == controller.targetUser.id;
                  return _buildChatBubble(theme, isMe, message.text);
                },
              );
            }),
          ),
          // 2. Area Input Teks
          _buildTextInput(theme),
        ],
      ),
    );
  }

  // Widget untuk gelembung chat
  Widget _buildChatBubble(ThemeData theme, bool isMe, String text) {
    // Tampilan dibalik: 'isMe' di sini berarti pesan dari USER
    final alignment = isMe ? Alignment.centerLeft : Alignment.centerRight;
    final color = isMe
        ? theme.colorScheme.onSurface.withOpacity(0.1)
        : theme.colorScheme.primary;
    final textColor =
        isMe ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary;

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(20),
            bottomRight: isMe ? const Radius.circular(20) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
      ),
    );
  }

  // Widget untuk input teks
  Widget _buildTextInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  hintText: 'Ketik balasan...',
                  filled: true,
                  fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 24,
              child: IconButton(
                icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
                onPressed: controller.sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
