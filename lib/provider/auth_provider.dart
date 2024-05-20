import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kithap_app/models/book.dart';
import 'package:kithap_app/models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;

  UserModel? get user => _user;

  Future<void> register(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName('$firstName $lastName');
      await userCredential.user!.reload();
      final updatedUser = _auth.currentUser;
      if (updatedUser != null) {
        _user = UserModel(
          uid: updatedUser.uid,
          email: updatedUser.email!,
          firstName: firstName,
          lastName: lastName,
          books: [],
        );
        await _saveUserToFirestore(_user!);
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      _user = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        firstName: userDoc['firstName'],
        lastName: userDoc['lastName'],
        books: (userDoc['books'] as List<dynamic>)
            .map((bookData) =>
                Book.fromMap(bookData as Map<String, dynamic>, ''))
            .toList(),
      );

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw e;
    }
  }

  Future<void> addBook(Book book) async {
    if (_user != null) {
      try {
        _user!.books.add(book);
        await _firestore.collection('users').doc(_user!.uid).update({
          'books': _user!.books.map((b) => b.toMap()).toList(),
        });

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();
        _user = UserModel(
          uid: _user!.uid,
          email: _user!.email,
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          books: (userDoc['books'] as List<dynamic>)
              .map((bookData) =>
                  Book.fromMap(bookData as Map<String, dynamic>, ''))
              .toList(),
        );

        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {}
  }

  Future<void> removeBook(Book book) async {
    if (_user != null) {
      try {
        _user!.books.remove(book);
        await _firestore.collection('users').doc(_user!.uid).update({
          'books': _user!.books.map((b) => b.toMap()).toList(),
        });

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();
        _user = UserModel(
          uid: _user!.uid,
          email: _user!.email,
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          books: (userDoc['books'] as List<dynamic>)
              .map((bookData) =>
                  Book.fromMap(bookData as Map<String, dynamic>, ''))
              .toList(),
        );

        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {}
  }

  Future<List<Book>> getBooks() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();
        List<Book> books = (userDoc['books'] as List<dynamic>)
            .map((bookData) =>
                Book.fromMap(bookData as Map<String, dynamic>, ''))
            .toList();
        return books;
      } catch (e) {
        throw e;
      }
    } else {
      return [];
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('signOut fonksiyonunda HATAA!!!! $e');
      throw e;
    }
  }
}
