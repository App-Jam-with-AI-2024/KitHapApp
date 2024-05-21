import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import '../colors.dart';
import '../models/book.dart';
import '../provider/auth_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController summaryMinutesController =
      TextEditingController();
  final TextEditingController summaryWordsController = TextEditingController();
  final TextEditingController extraNotesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    summaryMinutesController.dispose();
    summaryWordsController.dispose();
    extraNotesController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void _submitForm() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        (summaryMinutesController.text.isEmpty &&
            summaryWordsController.text.isEmpty)) {
      _showSnackBar(
          'Lütfen kitap ismini, yazar ismini ve özet uzunluğunu (dakika veya kelime) giriniz.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String summaryLength = summaryMinutesController.text.isNotEmpty
        ? '${summaryMinutesController.text} dakika'
        : '${summaryWordsController.text} kelime';
    String title = _capitalize(titleController.text);
    String author = _capitalize(authorController.text);
    String prompt =
        "$author yazarının yazdığı $title kitabının Özet Uzunluğu: $summaryLength olan ve ${extraNotesController.text} olacak şekilde bir kitap özeti oluşturur musun? Uzunluğunun $summaryLength olmasına dikkat et lütfen.";

    try {
      final summaryStream = Gemini.instance.streamGenerateContent(prompt);
      String aiSummary = "";

      await for (var value in summaryStream) {
        aiSummary += value.output.toString();
        if (aiSummary.length >= 2000) {
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

      await authProvider.addBook(book);
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
      _showSnackBar('Kitap başarıyla eklendi');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Kitap eklenirken hata oluştu: $error');
    }
  }

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
      title: const Text('Yeni Kitap Özeti Yarat',
          style: TextStyle(color: AppColors.textPrimary)),
      backgroundColor: AppColors.appBarBackground,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(titleController, 'Kitap Başlığı'),
            const SizedBox(height: 16.0),
            _buildTextField(authorController, 'Yazar'),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        summaryMinutesController, 'Özet Uzunluğu (dakika)',
                        isNumeric: true)),
                const SizedBox(width: 16.0),
                Expanded(
                    child: _buildTextField(
                        summaryWordsController, 'Özet Uzunluğu (kelime)',
                        isNumeric: true)),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildTextField(extraNotesController, 'Ekstra Notlar', maxLines: 5),
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumeric = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        fillColor: AppColors.cardBackground,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.textPrimary),
    );
  }
}
