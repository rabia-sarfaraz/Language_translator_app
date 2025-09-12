import 'package:flutter/material.dart';

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Translator",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Language Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: fromLanguage,
                  items: ["English", "Urdu", "French"]
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      fromLanguage = val!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                const Icon(Icons.swap_horiz, color: Colors.blue),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: toLanguage,
                  items: ["Spanish", "German", "Arabic"]
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      toLanguage = val!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Text Box
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Text here to translate...",
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.volume_up, color: Colors.blue),
                      Icon(Icons.mic, color: Colors.blue),
                      Icon(Icons.copy, color: Colors.blue),
                      Icon(Icons.share, color: Colors.blue),
                      Icon(Icons.send, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Translation API logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Translate",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            /// Bottom Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _BottomNavItem(Icons.translate, "Text Translation", true),
                _BottomNavItem(Icons.mic, "Voice Translation", false),
                _BottomNavItem(Icons.menu_book, "Dictionary", false),
                _BottomNavItem(Icons.chat, "Conversation", false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _BottomNavItem(this.icon, this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }
}
