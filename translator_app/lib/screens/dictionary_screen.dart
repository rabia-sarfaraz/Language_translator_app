import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _wordData;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchWord() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _wordData = null;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/$query",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            _wordData = data[0];
          });
        } else {
          setState(() {
            _errorMessage = "No meaning found for \"$query\".";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Word not found.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching word: $e";
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      body: Column(
        children: [
          const SizedBox(height: 33),

          // Top bar
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "assets/images/back.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Dictionary",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Big white box (input + results)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _searchWord(),
                      decoration: InputDecoration(
                        hintText: "Search word...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: primaryBlue),
                          onPressed: _searchWord,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (_errorMessage != null)
                      Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    if (_wordData != null) ...[
                      Text(
                        _wordData!["word"] ?? "",
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue, // ✅ highlight word in blue
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (_wordData!["phonetics"] != null &&
                          _wordData!["phonetics"].isNotEmpty)
                        Text(
                          "Pronunciation: ${_wordData!["phonetics"][0]["text"] ?? ""}",
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: ListView.builder(
                          itemCount: (_wordData!["meanings"] as List).length,
                          itemBuilder: (context, index) {
                            final meaning = _wordData!["meanings"][index];
                            final partOfSpeech = meaning["partOfSpeech"] ?? "";
                            final definitions = meaning["definitions"] as List;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    partOfSpeech.toUpperCase(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...definitions.map((def) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        "- ${def["definition"]}",
                                        style: GoogleFonts.roboto(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
