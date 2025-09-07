import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fromLang = "English";
  String toLang = "Urdu";
  String result = "";

  final TextEditingController _controller = TextEditingController();

  final List<String> languages = [
    "English",
    "Urdu",
    "Spanish",
    "French",
    "German",
    "Arabic",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Language Translator",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Lottie animation top
            Lottie.asset(
              "assets/animations/translate.json", // apni lottie file ka path
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),

            /// Input text field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter text to translate",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            /// Language selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// From Language
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromLang,
                    decoration: const InputDecoration(
                      labelText: "From",
                      border: OutlineInputBorder(),
                    ),
                    items: languages
                        .map(
                          (lang) =>
                              DropdownMenuItem(value: lang, child: Text(lang)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        fromLang = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),

                /// To Language
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toLang,
                    decoration: const InputDecoration(
                      labelText: "To",
                      border: OutlineInputBorder(),
                    ),
                    items: languages
                        .map(
                          (lang) =>
                              DropdownMenuItem(value: lang, child: Text(lang)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        toLang = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Translate Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  // Abhi dummy translation hai
                  result =
                      "${_controller.text} (Translated from $fromLang to $toLang)";
                });
              },
              child: Text(
                "Translate",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Result Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                result.isEmpty ? "Translation will appear here" : result,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
