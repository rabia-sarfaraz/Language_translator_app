import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 10 seconds baad next screen pe navigate karega
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // background #FFFFFF
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Lottie Animation
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Lottie.asset(
                    "assets/animations/translate.json",
                    width: 340,
                    height: 214,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            /// Welcome Texts
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8, // 👈 reduced from 20 to 8 (closer to left border)
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // left aligned
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        fontWeight: FontWeight.w700, // Bold
                        color: Colors.black, // black color
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Language Translate\nApp",
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        fontWeight: FontWeight.w700, // Bold
                        color: const Color(0xFF2C7DF7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Loader with "Loading..." vertically aligned
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30), // thoda neeche push kiya
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      RotatingIconLoader(assetPath: "assets/icons/loader.png"),
                      SizedBox(height: 8),
                      LoadingText(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom rotating loader using your icon
class RotatingIconLoader extends StatefulWidget {
  final String assetPath; // icon ka path
  const RotatingIconLoader({super.key, required this.assetPath});

  @override
  State<RotatingIconLoader> createState() => _RotatingIconLoaderState();
}

class _RotatingIconLoaderState extends State<RotatingIconLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        widget.assetPath,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Loading text with Inter typography
class LoadingText extends StatelessWidget {
  const LoadingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Loading...",
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700, // Bold
        color: Colors.black87,
      ),
    );
  }
}
