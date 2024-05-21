import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import '../colors.dart'; // colors.dart dosyasını içe aktarın

class BookSummaryScreen extends StatefulWidget {
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
  State<BookSummaryScreen> createState() => _BookSummaryScreenState();
}

class _BookSummaryScreenState extends State<BookSummaryScreen> {
  //FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    /*_flutterTts.getVoices.then((data) {
      try {
        List<Map> _voices = List<Map>.from(data);
        _voices =
            _voices.where((_voice) => _voice["name"].contains("tr")).toList();
        print(_voices);
        setState(() {});
      } catch (e) {
        print(e);
      }
    });*/
  }
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
                const SizedBox(height: 16.0),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Yazar: ${widget.author}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.summary,
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
