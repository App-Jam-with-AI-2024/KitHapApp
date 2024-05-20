import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final DateTime creationDate;
  final String description;
  final String aiSummary;
  final String imageUrl;
  final String summaryLength;
  final String summaryLanguage;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.creationDate,
    required this.description,
    required this.aiSummary,
    required this.imageUrl,
    required this.summaryLength,
    required this.summaryLanguage,
  });

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      creationDate: (data['creationDate'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      aiSummary: data['aiSummary'] ?? '',
      imageUrl:
          data['imageUrl'] ?? 'https://cdn.bkmkitap.com/1984-13451065-64-B.jpg',
      summaryLength: data['summaryLength'] ?? '',
      summaryLanguage: data['summaryLanguage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'creationDate': creationDate,
      'description': description,
      'aiSummary': aiSummary,
      'imageUrl': imageUrl,
      'summaryLength': summaryLength,
      'summaryLanguage': summaryLanguage,
    };
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, creationDate: $creationDate, description: $description, aiSummary: $aiSummary, imageUrl: $imageUrl, summaryLength: $summaryLength, summaryLanguage: $summaryLanguage}';
  }
}
