import 'package:flutter/material.dart';
import 'package:kithap_app/screens/AddBookScreen.dart';
import 'package:kithap_app/screens/BookSummaryScreen.dart';
import 'package:kithap_app/screens/LoginScreen.dart';
import 'package:kithap_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../colors.dart';
import '../models/book.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBooks);
    _refreshBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshBooks() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).getBooks();
      _filterBooks();
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  void _filterBooks() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final books = authProvider.user?.books ?? [];
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = books
          .where((book) =>
              book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _showDeleteConfirmationDialog(Book book) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          content: const Text('Are you sure you want to delete this summary?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
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

  Future<void> _deleteBook(Book book) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.removeBook(book);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book successfully deleted')),
      );
      _refreshBooks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting book: $e')),
      );
    }
  }

  void _logout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.user == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _filteredBooks.isEmpty
                    ? const Center(
                        child: Text('Henüz bir özetiniz bulunmamaktadır.',
                            style: TextStyle(color: AppColors.textPrimary)))
                    : _buildBookList();
              }
            },
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('KitHap', style: TextStyle(color: AppColors.textPrimary)),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Özetlerde Ara...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  fillColor: AppColors.cardBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 'logout', child: Text('Çıkış Yap')),
              ];
            },
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBookList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Text(
            'Books you summarized',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredBooks.length,
            itemBuilder: (context, index) {
              final book = _filteredBooks[index];
              return _buildBookCard(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(Book book) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: AppColors.cardBackground,
        shadowColor: AppColors.cardShadow,
        child: ListTile(
          title: Text(book.title,
              style: const TextStyle(color: AppColors.textPrimary)),
          subtitle: Text(book.author,
              style: const TextStyle(color: AppColors.textSecondary)),
          trailing:
              const Icon(Icons.arrow_forward, color: AppColors.textPrimary),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookSummaryScreen(
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
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddBookScreen()),
        );
        _refreshBooks();
      },
      backgroundColor: Colors.red,
      child: const Icon(Icons.add, color: AppColors.textPrimary),
    );
  }
}
