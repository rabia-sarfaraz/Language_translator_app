import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text_translation.dart'; // 👈 apni dusri screen import karna na bhoolna

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // 3 second baad agli screen pe navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TextTranslationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Stack(
        children: [
          /// Ellipse image
          Positioned(
            top: -2.59,
            left: 0,
            child: Image.asset(
              "assets/images/Ellipse.png", // apna ellipse image yahan rakho
              width: 508.36,
              height: 588.24,
              fit: BoxFit.contain,
            ),
          ),

          /// Text Positioned with given properties
          Positioned(
            top: 158,
            left: 20,
            child: SizedBox(
              width: 320,
              height: 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Language Translate",
                    style: GoogleFonts.roboto(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "App",
                    style: GoogleFonts.roboto(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Circular Progress Bar (center me)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 4,
            ),
          ),
        ],
      ),
    );
  }
}
