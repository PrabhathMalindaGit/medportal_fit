import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/home_page.dart';  // Make sure this import is present
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    return;
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;
  final AuthService _authService = AuthService();
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      // Remove the duplicate Firebase initialization
      final user = await _authService.getCurrentUser();
      setState(() {
        _user = user;
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitnestX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : _error 
              ? const Center(child: Text('Error initializing app'))
              : _user == null
                  ? const LandingPage()
                  : const HomePage(),  // Now HomePage should be recognized
    );
  }
}
