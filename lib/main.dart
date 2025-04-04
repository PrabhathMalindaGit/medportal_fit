import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/home_page.dart';  // Make sure this import is present
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';
import 'package:provider/provider.dart';
import 'services/progress_photo_service.dart';
import 'models/progress_photo.dart';

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
    return MultiProvider(
      providers: [
        Provider<ProgressPhotoService>(
          create: (_) => ProgressPhotoService(),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        home: !_initialized
            ? const Center(child: CircularProgressIndicator())
            : _error 
                ? const Center(child: Text('Error initializing app'))
                : _user == null
                    ? const LandingPage()
                    : const HomePage(),  // Now HomePage should be recognized
      ),
    );
  }
}

class ProgressPhotoScreen extends StatelessWidget {
  const ProgressPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Photos'),
      ),
      body: StreamBuilder<List<ProgressPhoto>>(
        stream: context.read<ProgressPhotoService>().getProgressPhotosByUser('test_user'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final photos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return ListTile(
                leading: Image.network(photo.thumbnailUrl),
                title: Text(photo.category),
                subtitle: Text(photo.date.toString()),
                trailing: Text('${photo.weight} kg'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement photo upload
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
