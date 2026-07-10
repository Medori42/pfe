import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/futuristic_background.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  int _hoveredBadgeIndex = -1;
  bool _isShareHovered = false;

  final List<Map<String, dynamic>> _badges = [
    {
      'title': 'Expert en Sécurité',
      'subtitle': 'HSE Expert - Module 2',
      'icon': Icons.engineering_rounded,
      'isGold': true,
      'isLocked': false,
    },
    {
      'title': 'Ambassadeur des Valeurs',
      'subtitle': 'Ambassadeur - Intégration',
      'icon': Icons.favorite_rounded,
      'isGold': true,
      'isLocked': false,
    },
    {
      'title': 'Explorateur Actif',
      'subtitle': 'Explorateur - Module 1',
      'icon': Icons.search_rounded,
      'isGold': false,
      'isLocked': false,
    },
    {
      'title': 'Héros de la Vitesse',
      'subtitle': 'Quiz - Record de temps',
      'icon': Icons.flash_on_rounded,
      'isGold': false,
      'isLocked': false,
    },
    {
      'title': 'Badge Verrouillé',
      'subtitle': 'Module 4 requis',
      'icon': Icons.lock_outline_rounded,
      'isGold': false,
      'isLocked': true,
    },
    {
      'title': 'Badge Verrouillé',
      'subtitle': 'Module 5 requis',
      'icon': Icons.lock_outline_rounded,
      'isGold': false,
      'isLocked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCEB395), // Warm ocre/beige
      body: Stack(
        children: [
          // Background Tech Constellations
          Positioned.fill(
            child: CustomPaint(
              painter: FuturisticTechBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600), // Enforce desktop responsiveness
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Top Header Row (Logo WelcomeWise & Page Title)
                      _buildHeaderRow(),
                      const SizedBox(height: 20),

                      // 2. Central Content Card (White & Rounded)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 3. Employee ID Section (Avatar & Info)
                            _buildUserInfo(),
                            const SizedBox(height: 24),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 24),

                            // 4. Global Progress Bar & Badge Counter
                            _buildProgressAndBadgesHeader(),
                            const SizedBox(height: 24),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 24),

                            // 5. Grid of Badges
                            const Text(
                              "Badges & Récompenses",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildBadgesGrid(),
                            const SizedBox(height: 32),

                            // 6. Action Button (Share)
                            _buildShareButton(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 7. Footer
                      const Center(
                        child: Text(
                          "Ménara Holding © 2026",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Back button + logo
        Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primaryBlue,
                      child: const Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "WelcomeWise",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        // Right: Translated Title
        const Text(
          "Mon Profil Personnel",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Avatar circular with drop shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFF1F5F9),
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120',
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Info texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Meryem FATHI",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Nouvelle employée (BTP)",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Département : HSE / Béton",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressAndBadgesHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progression Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Progression Globale",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            Text(
              "75%",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Premium horizontal progress bar
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 75,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC9A84C), Color(0xFFE2B93B)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const Expanded(
                flex: 25,
                child: SizedBox(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Badge counter
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD54F), width: 0.5),
              ),
              child: const Text(
                "Badges obtenus : 4/10",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB7791F),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.88,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        final badge = _badges[index];
        final isHovered = _hoveredBadgeIndex == index;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredBadgeIndex = index),
          onExit: (_) => setState(() => _hoveredBadgeIndex = -1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: isHovered && !badge['isLocked']
                ? (Matrix4.identity()..translate(0, -4))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: badge['isLocked']
                    ? const Color(0xFFE2E8F0)
                    : isHovered
                        ? (badge['isGold'] ? const Color(0xFFFFD700) : const Color(0xFF60A5FA))
                        : const Color(0xFFF1F5F9),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: badge['isLocked']
                      ? Colors.transparent
                      : isHovered
                          ? (badge['isGold']
                              ? const Color(0xFFFFD700).withOpacity(0.25)
                              : const Color(0xFF60A5FA).withOpacity(0.25))
                          : Colors.black.withOpacity(0.02),
                  blurRadius: isHovered ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Opacity(
              opacity: badge['isLocked'] ? 0.5 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Shield Container with Icon
                  _buildBadgeShield(badge),
                  const SizedBox(height: 10),
                  // Badge Title
                  Text(
                    badge['title'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Badge Subtitle
                  Text(
                    badge['subtitle'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: badge['isLocked'] ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadgeShield(Map<String, dynamic> badge) {
    Color ringColor;
    Color centerColor;
    Color iconColor;

    if (badge['isLocked']) {
      ringColor = const Color(0xFFCBD5E1);
      centerColor = const Color(0xFFF1F5F9);
      iconColor = const Color(0xFF94A3B8);
    } else if (badge['isGold']) {
      ringColor = const Color(0xFFFFD700);
      centerColor = const Color(0xFFFFFBEB);
      iconColor = const Color(0xFFD97706);
    } else {
      ringColor = const Color(0xFF3B82F6);
      centerColor = const Color(0xFFEFF6FF);
      iconColor = const Color(0xFF2563EB);
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: centerColor,
        border: Border.all(color: ringColor, width: 2),
        boxShadow: badge['isLocked']
            ? null
            : [
                BoxShadow(
                  color: ringColor.withOpacity(0.15),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Center(
        child: Icon(
          badge['icon'],
          size: 32,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isShareHovered = true),
      onExit: (_) => setState(() => _isShareHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isShareHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)], // Elegant Royal Blue Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withOpacity(_isShareHovered ? 0.35 : 0.2),
                blurRadius: _isShareHovered ? 16 : 8,
                spreadRadius: _isShareHovered ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Récompenses partagées avec succès !"),
                    backgroundColor: Color(0xFF1E40AF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.share, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "PARTAGER MES RÉCOMPENSES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
