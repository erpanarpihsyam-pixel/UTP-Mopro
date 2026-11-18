import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SeduhKopiApp());
}

class SeduhKopiApp extends StatelessWidget {
  const SeduhKopiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeduhKopi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6F4E37),
          primary: const Color(0xFF4E342E),
          secondary: const Color(0xFFD7CCC8),
          surface: const Color(0xFFF9F7F4),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4E342E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 1,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4E342E),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

