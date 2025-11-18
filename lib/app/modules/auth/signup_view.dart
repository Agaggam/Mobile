import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/auth/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // --- APPBAR BARU ---
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      // --- AKHIR APPBAR ---
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isKeyboardOpen ? 10 : 30),

                // --- JUDUL BARU ---
                Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your thrifting journey!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // --- AKHIR JUDUL ---

                SizedBox(height: isKeyboardOpen ? 20 : 50),

                // --- FORM BARU ---
                _buildFormSection(theme, colorScheme),
                // --- AKHIR FORM ---

                SizedBox(height: isKeyboardOpen ? 20 : 30),

                // --- LINK LOGIN BARU ---
                _buildLoginSection(theme, colorScheme),
                SizedBox(height: isKeyboardOpen ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- FORM SECTION BARU ---
  Widget _buildFormSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Email TextField
        _buildTextFieldWithIcon(
          controller: controller.emailSignUpController,
          label: 'Email',
          hint: 'Masukkan email Anda',
          icon: Icons.email_outlined,
          theme: theme,
          colorScheme: colorScheme,
          obscure: false,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),

        // Password TextField
        Obx(() => _buildTextFieldWithIcon(
              controller: controller.passwordSignUpController,
              label: 'Password',
              hint: 'Minimal 6 karakter',
              icon: Icons.lock_outline,
              theme: theme,
              colorScheme: colorScheme,
              obscure: controller
                  .isSignUpPasswordHidden.value, // Gunakan variabel Sign Up
              isPasswordField: true,
              onToggleVisibility: controller
                  .toggleSignUpPasswordVisibility, // Gunakan method Sign Up
            )),

        const SizedBox(height: 30),

        // Create Account Button
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoadingSignUp.value
                  ? null
                  : controller.signUpWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: controller.isLoadingSignUp.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'CREATE ACCOUNT',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable TextField (Sama seperti di LoginView)
  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool obscure,
    TextInputType keyboardType = TextInputType.text,
    bool isPasswordField = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: colorScheme.primary.withOpacity(0.7),
            ),
            suffixIcon: isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: colorScheme.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  // --- LINK LOGIN BARU ---
  Widget _buildLoginSection(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sudah punya akun? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(), // Kembali ke halaman login
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Login di sini',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
