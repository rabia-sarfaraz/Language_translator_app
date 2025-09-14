import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
// Alias imports to avoid name conflicts
import 'screens/text_translation.dart' as tscreen;
import 'screens/text_translation1.dart' as tscreen1;

void main() {
  runApp(const TranslatorApp());
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Language Translator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/text_translation': (context) => const tscreen.TextTranslationScreen(),
        // For TextTranslation1Screen, if it has required params, remove const and pass dummy values
        '/text_translation1': (context) => tscreen1.TextTranslation1Screen(
          originalText: "",
          translatedText: "",
          fromLanguage: "English",
          toLanguage: "Spanish",
        ),
      },
    );
  }
}
