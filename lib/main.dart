import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '/theme/app_theme.dart' show lightTheme, darkTheme;
import '/config/app_pages.dart';
import '/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    throw Exception('Firebase initialization error: $e');
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  // Initialize shared_preferences and check rememberMe
  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? true;
  if (!rememberMe) {
    await firebase_auth.FirebaseAuth.instance.signOut();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  void toggleTheme(bool enableDark) {
    setState(() {
      isDarkMode = enableDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christos Poulis',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthWrapper(),
      initialRoute: AppPages.splash,
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        quill.FlutterQuillLocalizations.delegate,
      ],
      routes: AppPages.routes,
      onGenerateRoute: AppPages.onGenerateRoute,
    );
  }
}
