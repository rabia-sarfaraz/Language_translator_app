import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Stack(
        children: [
          /// Ellipse image (tum apna path dogi assets/images/ellipse.png)
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
        ],
      ),
    );
  }
}
