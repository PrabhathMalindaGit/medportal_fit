import 'dart:async';
import 'package:flutter/foundation.dart';  // Add this import
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add this getter
  User? get currentUser {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      firstName: '',  // These will be updated by authStateChanges
      lastName: '',
      stats: {},
      profileImage: null,
    );
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      try {
        final userData = await _db
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        
        if (!userData.exists) return null;
        
        return User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          firstName: userData.data()?['firstName'] ?? '',
          lastName: userData.data()?['lastName'] ?? '',
          stats: Map<String, String>.from(userData.data()?['stats'] ?? {}),
          profileImage: userData.data()?['profileImage'],
        );
      } catch (e) {
        debugPrint('Error fetching user data: $e');
        return null;
      }
    });
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final userData = await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userData.exists) return null;

      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        firstName: userData.data()?['firstName'] ?? '',
        lastName: userData.data()?['lastName'] ?? '',
        stats: Map<String, String>.from(userData.data()?['stats'] ?? {}),
      );
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      print('Starting registration process...'); // Add debug print
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
  
      if (result.user == null) {
        throw Exception('Registration failed - no user returned');
      }
  
      // Update the user's display name
      await result.user!.updateDisplayName('$firstName $lastName');
  
      final user = User(
        id: result.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        stats: {
          'height': '180cm',
          'weight': '65kg',
          'age': '22yo',
        },
      );
  
      // Store additional user data in Firestore
      await _db.collection('users').doc(result.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'stats': user.stats,
      });
  
      print('Registration completed successfully'); // Add debug print
      return user;
    } catch (e) {
      print('Registration error in service: $e'); // Add debug print
      throw _handleAuthError(e);
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      final userData = await _db
          .collection('users')
          .doc(result.user!.uid)
          .get();

      return User(
        id: result.user!.uid,
        firstName: userData.data()?['firstName'] ?? '',
        lastName: userData.data()?['lastName'] ?? '',
        email: email,
        stats: Map<String, String>.from(userData.data()?['stats'] ?? {}),
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Exception _handleAuthError(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return Exception('Email already registered');
        case 'invalid-email':
          return Exception('Invalid email address');
        case 'weak-password':
          return Exception('Password is too weak');
        case 'user-not-found':
          return Exception('User not found');
        case 'wrong-password':
          return Exception('Incorrect password');
        default:
          return Exception('Authentication failed');
      }
    }
    return Exception('Something went wrong');
  }
}