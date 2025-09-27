import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const SizedBox(height: 36),

          /// 🔹 Top Rectangle Bar
          Container(
            height: 56,
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Settings",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.settings, color: Colors.blue, size: 24),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🔹 Card with options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildOption(
                    icon: Icons.share,
                    title: "Share",
                    subtitle: "Share app with friends",
                  ),
                  _divider(),
                  _buildOption(
                    icon: Icons.star_border,
                    title: "Rate us",
                    subtitle: "Rate your experience",
                  ),
                  _divider(),
                  _buildOption(
                    icon: Icons.language,
                    title: "Language",
                    subtitle: "Auto (English)",
                  ),
                  _divider(),
                  _buildOption(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy policy",
                    subtitle: "Read our privacy policy",
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          /// 🔹 Bottom Navigation
          Container(
            height: 56,
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNav(
                  icon: Icons.text_fields,
                  label: "Text Translation",
                  active: false,
                ),
                _BottomNav(
                  icon: Icons.mic_none,
                  label: "Voice Translation",
                  active: false,
                ),
                _BottomNav(
                  icon: Icons.menu_book_outlined,
                  label: "Dictionary",
                  active: false,
                ),
                _BottomNav(
                  icon: Icons.chat_bubble_outline,
                  label: "Conversation",
                  active: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.black.withOpacity(0.08),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.roboto(fontSize: 13, color: Colors.black54),
      ),
      onTap: () {
        // 👉 Add actions here later
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNav({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: active ? primaryBlue : bottomInactive),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: active ? primaryBlue : bottomInactive,
          ),
        ),
      ],
    );
  }
}
