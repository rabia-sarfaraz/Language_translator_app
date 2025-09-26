import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/text_translation.dart';
import 'screens/voice_translation.dart';
import 'screens/dictionary_screen.dart';
import 'screens/conversation_screen.dart';

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
        '/text_translation': (context) => const TextTranslationScreen(),
        '/voice_translation': (context) => const VoiceTranslationScreen(),
        'dictionary': (context) => const DictionaryScreen(),
        'conversation': (context) => const ConversationScreen(),
      },
    );
  }
}
