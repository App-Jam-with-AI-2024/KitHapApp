import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import '../colors.dart'; // colors.dart dosyasını içe aktarın
import '../models/book.dart'; // Book modelini içe aktarın
import '../provider/auth_provider.dart'; // AuthProvider'ı içe aktarın

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController =
      TextEditingController(text: "1984");
  final TextEditingController authorController =
      TextEditingController(text: "George Orwell");
  final TextEditingController summaryMinutesController =
      TextEditingController(text: "2");
  final TextEditingController summaryWordsController = TextEditingController();
  final TextEditingController extraNotesController = TextEditingController(
      text: "Resmi bir dille yazılmış bir özet istiyorum.");
  bool _isLoading = false; // Loading durumu için değişken
  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void _submitForm() async {
    final gemini = Gemini.instance;
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        (summaryMinutesController.text.isEmpty &&
            summaryWordsController.text.isEmpty)) {
      _showSnackBar(
          'Lütfen kitap ismini, yazar ismini ve özet uzunluğunu (dakika veya kelime) giriniz.');
      return;
    }
    setState(() {
      _isLoading = true; // İşlem başlarken loading'i aç
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String summaryLength;
    if (summaryMinutesController.text.isNotEmpty) {
      summaryLength = '${summaryMinutesController.text} dakika';
    } else if (summaryWordsController.text.isNotEmpty) {
      summaryLength = '${summaryWordsController.text} kelime';
    } else {
      summaryLength = 'Uzunluk belirtilmedi';
    }
    try {
      // Kitap adı ve yazar adını düzenleme
      String title = _capitalize(titleController.text);
      String author = _capitalize(authorController.text);
      // Prompt oluşturma
      final prompt =
          "$author yazarının yazdığı $title kitabının Özet Uzunluğu: $summaryLength olan ve ${extraNotesController.text} olacak şekilde bir kitap özeti oluşturur musun? Uzunluğunun $summaryLength olmasına dikkat et lütfen.";
      print(prompt);
      // Özet oluşturma
      final summaryStream = gemini.streamGenerateContent(prompt);
      String aiSummary = "";
      await for (var value in summaryStream) {
        aiSummary += value.output.toString();
        if (aiSummary.length >= 2000) {
          // Belirli bir uzunluğa ulaşıldığında kes
          break;
        }
      }
      final book = Book(
        id: '',
        title: title,
        author: author,
        creationDate: DateTime.now(),
        description: extraNotesController.text,
        aiSummary: aiSummary,
        imageUrl: 'https://cdn.bkmkitap.com/1984-13451065-64-B.jpg',
        summaryLength: summaryLength,
      );
      // Kitap bilgilerini veritabanına ekleme
      await authProvider.addBook(book);
      setState(() {
        _isLoading = false; // İşlem bitince loading'i kapat
      });
      Navigator.pop(context);
      _showSnackBar('Kitap başarıyla eklendi');
    } catch (error) {
      setState(() {
        _isLoading = false; // Hata durumunda loading'i kapat
      });
      _showSnackBar('Kitap eklenirken hata oluştu: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Kitap Özeti Yarat',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Kitap Başlığı',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  fillColor: AppColors.cardBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: 'Yazar',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  fillColor: AppColors.cardBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: summaryMinutesController,
                      decoration: InputDecoration(
                        labelText: 'Özet Uzunluğu (dakika)',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        fillColor: AppColors.cardBackground,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: summaryWordsController,
                      decoration: InputDecoration(
                        labelText: 'Özet Uzunluğu (kelime)',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        fillColor: AppColors.cardBackground,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: extraNotesController,
                decoration: InputDecoration(
                  labelText: 'Ekstra Notlar',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  fillColor: AppColors.cardBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 5,
                style: TextStyle(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                child: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary),
                        ),
                      )
                    : const Text('Özet Yarat',
                        style: TextStyle(color: AppColors.textPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
