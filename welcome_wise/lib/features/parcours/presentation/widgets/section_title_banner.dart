import 'package:flutter/material.dart';

class SectionTitleBanner extends StatelessWidget {
  final String title;
  const SectionTitleBanner({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBF9), // Creamy white background to break the ocre tone
        borderRadius: BorderRadius.circular(30), // Rounded pills
        border: Border.all(
          color: const Color(0xFFD4AF37), // Elegant gold/bronze border
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Subtle 3D shadow relief
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withOpacity(0.5), // Elegant gold line
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A), // Deep night blue for readability
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withOpacity(0.5), // Elegant gold line
            ),
          ),
        ],
      ),
    );
  }
}
