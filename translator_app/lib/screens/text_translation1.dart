import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Language codes (sirf UI ke liye, translation yahan nahi ho rahi)
const Map<String, String> languageCodes = {
  "English": "en",
  "Spanish": "es",
  "Urdu": "ur",
  "French": "fr",
  "German": "de",
  "Arabic": "ar",
};

class TextTranslation1Screen extends StatefulWidget {
  const TextTranslation1Screen({super.key});

  @override
  State<TextTranslation1Screen> createState() => _TextTranslation1ScreenState();
}

class _TextTranslation1ScreenState extends State<TextTranslation1Screen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  String translatedText = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Receive translated text from previous screen
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("translatedText")) {
      translatedText = args["translatedText"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                      "Translator",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Image.asset("assets/images/setting.png", height: 24, width: 24),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Language selectors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageButton(fromLanguage, isFrom: true),
                Container(
                  width: 46,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/center_icon.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                _buildLanguageButton(toLanguage, isFrom: false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Translated result box (blue rectangle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Left top image
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Image.asset(
                      "assets/images/inside_left.png",
                      width: 56,
                      height: 56,
                    ),
                  ),
                  // Translated text
                  Positioned(
                    top: 60,
                    left: 12,
                    right: 12,
                    child: Text(
                      translatedText.isEmpty
                          ? "No translation received"
                          : translatedText,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  // Bottom icons
                  Positioned(
                    left: 12,
                    bottom: 8,
                    right: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/icon1.png",
                          width: 28,
                          height: 28,
                          color: Colors.white,
                        ),
                        Image.asset(
                          "assets/images/icon2.png",
                          width: 28,
                          height: 28,
                          color: Colors.white,
                        ),
                        Image.asset(
                          "assets/images/icon3.png",
                          width: 28,
                          height: 28,
                          color: Colors.white,
                        ),
                        Image.asset(
                          "assets/images/icon4.png",
                          width: 28,
                          height: 28,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Bottom nav
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(height: 2, width: 40, color: primaryBlue),
                    const SizedBox(height: 4),
                    Image.asset(
                      "assets/images/bottom_text.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Text Translation",
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_voice.png",
                  label: "Voice Translation",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_dict.png",
                  label: "Dictionary",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_conv.png",
                  label: "Conversation",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Language Button (unchanged UI)
  Widget _buildLanguageButton(String lang, {required bool isFrom}) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          if (isFrom) {
            fromLanguage = value;
          } else {
            toLanguage = value;
          }
        });
      },
      itemBuilder: (context) {
        return languageCodes.keys.map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
      child: Container(
        width: 130,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang,
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;

  const _BottomNav({
    required this.iconPath,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, width: 20, height: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: active ? activeColor : inactiveColor,
          ),
        ),
      ],
    );
  }
}
