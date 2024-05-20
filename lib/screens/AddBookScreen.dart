import 'package:flutter/material.dart';
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
      TextEditingController(text: "25");
  final TextEditingController summaryWordsController = TextEditingController();
  final TextEditingController extraNotesController = TextEditingController(
      text: "Eğlenceli bir dille yazılmış bir özet istiyorum.");
  final TextEditingController languageController =
      TextEditingController(text: "Türkçe"); // Yeni eklenen alan

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submitForm() {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        (summaryMinutesController.text.isEmpty &&
            summaryWordsController.text.isEmpty)) {
      _showSnackBar(
          'Lütfen kitap ismini, yazar ismini ve özet uzunluğunu (dakika veya kelime) giriniz.');
    } else if (languageController.text.isEmpty) {
      _showSnackBar('Lütfen özetin dilini giriniz.');
    } else {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String summaryLength;
      if (summaryMinutesController.text.isNotEmpty) {
        summaryLength = '${summaryMinutesController.text} dakika';
      } else if (summaryWordsController.text.isNotEmpty) {
        summaryLength = '${summaryWordsController.text} kelime';
      } else {
        summaryLength = 'Uzunluk belirtilmedi';
      }

      final book = Book(
        id: '',
        title: titleController.text,
        author: authorController.text,
        creationDate: DateTime.now(),
        description: extraNotesController.text,
        aiSummary: '',
        imageUrl: 'https://cdn.bkmkitap.com/1984-13451065-64-B.jpg',
        summaryLength: summaryLength,
        summaryLanguage: languageController.text, // Yeni eklenen alan
      );

      // Prompt oluşturma
      final prompt =
          " Kitap Adı: ${titleController.text} Yazar: ${authorController.text} Özet Uzunluğu: $summaryLength Özel İstek: ${extraNotesController.text} Dil: ${languageController.text} Lütfen yukarıdaki bilgilere göre bir özet oluşturun.";

      print(prompt); // Konsola yazdır

      authProvider.addBook(book).then((_) {
        Navigator.pop(context);
        _showSnackBar('Kitap başarıyla eklendi');
      }).catchError((error) {
        _showSnackBar('Kitap eklenirken hata oluştu: $error');
      });
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
                controller: languageController, // Yeni eklenen alan
                decoration: InputDecoration(
                  labelText: 'Özet Dili', // Yeni eklenen alan
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
                child: const Text('Özet Yarat',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
