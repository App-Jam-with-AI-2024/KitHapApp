import 'package:flutter/material.dart';
import '../colors.dart';

class BookSummaryScreen extends StatelessWidget {
  final String title;
  final String author;
  final String summary;

  const BookSummaryScreen({
    super.key,
    required this.title,
    required this.author,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.background,
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Kitap Özeti',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      backgroundColor: AppColors.appBarBackground,
      iconTheme: const IconThemeData(
        color: Colors.white, // Geri butonunun rengini beyaz yap
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              _buildTitle(),
              const SizedBox(height: 8.0),
              _buildAuthor(),
              const SizedBox(height: 16.0),
              _buildSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildAuthor() {
    return Text(
      'Yazar: $author',
      style: const TextStyle(
        fontSize: 18,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildSummary() {
    return Text(
      summary,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
    );
  }
}
