import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MediathequeSection extends StatelessWidget {
  const MediathequeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row of 3 Cards
        Row(
          children: [
            Expanded(
              child: _buildDocCard(
                icon: Icons.description,
                title: "Guide de l'employé (PDF)",
                subtitle: "Livret d'accueil",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDocCard(
                icon: Icons.contact_phone,
                title: "Contacts Importants",
                subtitle: "Liste des contacts",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDocCard(
                icon: Icons.map,
                title: "Plan des Sites",
                subtitle: "Sièges sociaux",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.gold,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
