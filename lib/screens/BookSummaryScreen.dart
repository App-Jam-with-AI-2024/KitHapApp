import 'package:flutter/material.dart';
import '../colors.dart'; // colors.dart dosyasını içe aktarın

class BookSummaryScreen extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final String summary;

  const BookSummaryScreen({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kitap Özeti',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(
          color: Colors.white, // Geri butonunun rengini beyaz yap
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(image),
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Yazar: $author',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Kitabı sesli dinle işlemi burada gerçekleştirilecek
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            'Kitabı Sesli Dinle',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
