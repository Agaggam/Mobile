import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/search/search_controller.dart';
import 'package:google_fonts/google_fonts.dart';
// --- IMPORT BARU ---
import 'package:intl/intl.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchC,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: colorScheme.onSurface),
              onPressed: controller.clearSearch,
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
          onSubmitted: controller.performSearch,
        ),
        backgroundColor: colorScheme.surface,
      ),
      // ... (body Obx() tidak berubah)
      body: Obx(() {
        // ... (logika if loading tidak berubah)
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ... (logika if searchResults tidak berubah)
        if (controller.searchResults.isNotEmpty) {
          return _buildSearchResults(theme);
        }

        // ... (logika if hasSearched tidak berubah)
        if (controller.hasSearched.value) {
          return _buildEmptyState(
            theme,
            Icons.search_off,
            'Produk Tidak Ditemukan',
            'Coba gunakan kata kunci lain untuk pencarian Anda.',
          );
        }

        // ... (logika if searchHistory tidak berubah)
        if (controller.searchHistory.isNotEmpty) {
          return _buildSearchHistory(theme);
        }

        // ... (logika _buildEmptyState tidak berubah)
        return _buildEmptyState(
          theme,
          Icons.search,
          'Mulai Mencari',
          'Ketik nama produk yang ingin Anda temukan.',
        );
      }),
    );
  }

  // ... (_buildSearchHistory tidak berubah)
  Widget _buildSearchHistory(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Pencarian',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: controller.clearSearchHistory,
                child: Text(
                  'HAPUS',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final term = controller.searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(term),
                onTap: () => controller.onHistoryTap(term),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan hasil pencarian
  Widget _buildSearchResults(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final product = controller.searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Image.network(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            title: Text(
              product.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // --- PERUBAHAN HARGA ---
            subtitle: Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(product.price),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            // --- AKHIR PERUBAHAN ---
            onTap: () => controller.goToProductDetail(product),
          ),
        );
      },
    );
  }

  // ... (_buildEmptyState tidak berubah)
  Widget _buildEmptyState(
      ThemeData theme, IconData icon, String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
