import 'dart:math';
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
          /// Ellipse with exact size, position and rotation
          Positioned(
            left: 0, // X position set karo agar adjust karna ho
            top: -2.59, // Y position
            child: Transform.rotate(
              angle: -11.26 * pi / 180, // Rotation in radians
              child: Container(
                width: 508.36,
                height: 588.24,
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
