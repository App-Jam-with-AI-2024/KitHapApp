import 'package:cloud_firestore/cloud_firestore.dart';
import 'book.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final List<Book> books;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.books,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      books: (data['books'] as List<dynamic>)
          .map((bookData) => Book.fromMap(bookData, ''))
          .toList(),
    );
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      firstName: user.displayName?.split(' ').first ?? '',
      lastName: user.displayName?.split(' ').last ?? '',
      books: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'books': books.map((book) => book.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, books: ${books.map((book) => book.toString()).toList()}}';
  }
}
