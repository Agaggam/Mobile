import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shipping_address/shipping_address_controller.dart';

class AddressFormView extends GetView<ShippingAddressController> {
  const AddressFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Cek apakah ini mode edit atau tambah
    final addressId = Get.arguments as int?;
    final isEditMode = addressId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Alamat' : 'Tambah Alamat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Penerima
            _buildTextField(
              theme,
              colorScheme,
              'Nama Penerima',
              'Masukkan nama penerima',
              Icons.person_outline,
              controller.nameController,
            ),
            const SizedBox(height: 20),

            // Nomor Telepon
            _buildTextField(
              theme,
              colorScheme,
              'Nomor Telepon',
              'Contoh: 08123456789',
              Icons.phone_outlined,
              controller.phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Alamat Lengkap
            _buildTextField(
              theme,
              colorScheme,
              'Alamat Lengkap',
              'Jalan, No. Rumah, RT/RW',
              Icons.home_outlined,
              controller.addressController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Kota
            _buildTextField(
              theme,
              colorScheme,
              'Kota',
              'Masukkan nama kota',
              Icons.location_city_outlined,
              controller.cityController,
            ),
            const SizedBox(height: 20),

            // Provinsi
            _buildTextField(
              theme,
              colorScheme,
              'Provinsi',
              'Masukkan nama provinsi',
              Icons.map_outlined,
              controller.provinceController,
            ),
            const SizedBox(height: 20),

            // Kode Pos
            _buildTextField(
              theme,
              colorScheme,
              'Kode Pos',
              'Contoh: 65141',
              Icons.markunread_mailbox_outlined,
              controller.postalCodeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Checkbox Jadikan Default
            Obx(() => CheckboxListTile(
              value: controller.isDefaultAddress.value,
              onChanged: (value) {
                controller.isDefaultAddress.value = value ?? false;
              },
              title: Text(
                'Jadikan sebagai alamat default',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            )),

            const SizedBox(height: 32),

            // Save Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (isEditMode) {
                            controller.updateAddress(addressId);
                          } else {
                            controller.createAddress();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditMode ? 'UPDATE ALAMAT' : 'SIMPAN ALAMAT',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String hint,
    IconData icon,
    TextEditingController textController, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
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
          controller: textController,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
            filled: true,
            fillColor: colorScheme.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}