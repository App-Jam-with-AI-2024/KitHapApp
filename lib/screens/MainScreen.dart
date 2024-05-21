import 'package:flutter/material.dart';
import 'package:kithap_app/screens/AddBookScreen.dart';
import 'package:kithap_app/screens/BookSummaryScreen.dart';
import 'package:kithap_app/screens/LoginScreen.dart';
import 'package:kithap_app/screens/ProfileScreen.dart';
import 'package:kithap_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../colors.dart'; // colors.dart dosyasını içe aktarın
import '../models/book.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _refreshBooks() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).getBooks();
    } catch (e) {
      print('initState fonksiyonunda HATAA!!!! $e');
    }
  }

  void _showDeleteConfirmationDialog(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silmek istediğinize emin misiniz?'),
          content: const Text('Bu özeti silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              child: const Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Evet'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBook(book);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(Book book) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.removeBook(book);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kitap başarıyla silindi'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Kitap silinirken hata oluştu: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KitHap',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle:
                          const TextStyle(color: AppColors.textSecondary),
                      fillColor: AppColors.cardBackground,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  } else if (value == 'logout') {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    authProvider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                        value: 'profile', child: Text('Profil')),
                    const PopupMenuItem(
                        value: 'logout', child: Text('Çıkış yap')),
                  ];
                },
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.user == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final books = authProvider.user!.books;
                return books.isEmpty
                    ? const Center(
                        child: Text('Henüz özetlediğiniz kitap yok.'))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0),
                            child: Text(
                              'Özetini okuduğunuz kitaplar',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: AppColors.cardBackground,
                                    shadowColor: AppColors.cardShadow,
                                    child: ListTile(
                                      title: Text(
                                        book.title,
                                        style: const TextStyle(
                                            color: AppColors.textPrimary),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.author,
                                            style: const TextStyle(
                                                color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(Icons.arrow_forward,
                                          color: AppColors.textPrimary),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookSummaryScreen(
                                              title: book.title,
                                              author: book.author,
                                              summary: book.aiSummary,
                                            ),
                                          ),
                                        );
                                      },
                                      onLongPress: () {
                                        _showDeleteConfirmationDialog(book);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBookScreen()),
            );
            _refreshBooks();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
