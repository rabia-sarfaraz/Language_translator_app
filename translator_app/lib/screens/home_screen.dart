import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: Stack(
        children: [
          /// Ellipse Gradient (Center me ellipse)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Color.fromRGBO(44, 125, 247, 0.30), // 30%
                    Color.fromRGBO(44, 125, 247, 0.20), // 20%
                    Color.fromRGBO(44, 125, 247, 0.02), // 2%
                  ],
                  stops: [0.0, 0.53, 0.96],
                ),
              ),
            ),
          ),

          /// Center Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Language Translate",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "App",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
