import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tentang Aplikasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.card_giftcard, size: 64, color: AppColors.primaryColor),
                  SizedBox(height: 8),
                  Text('WeddingApp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tentang Aplikasi', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'WeddingApp membantu Anda menemukan dekorasi bunga pernikahan yang sempurna. Jelajahi paket, cari dengan gambar, dan pesan dengan mudah.',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: AppSizes.xl),
            Text('Versi', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            const Text('1.0.0', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
