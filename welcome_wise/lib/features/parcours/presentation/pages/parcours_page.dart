import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../auth/presentation/bloc/login_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/ai_quiz_section.dart';
import '../widgets/greeting_card.dart';
import '../widgets/mediatheque_section.dart';
import '../widgets/roadmap_path.dart';
import '../widgets/section_title_banner.dart';
import '../widgets/futuristic_navbar.dart';
import '../widgets/futuristic_background.dart';

class ParcoursPage extends StatefulWidget {
  const ParcoursPage({super.key});

  @override
  State<ParcoursPage> createState() => _ParcoursPageState();
}

class _ParcoursPageState extends State<ParcoursPage> {

  void _logout() {
    context.read<LoginBloc>().add(const LoginReset());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCEB395), // Chaleureuse couleur ocre/beige de l'image image_808485.png
      appBar: FuturisticNavbar(onLogout: _logout),
      body: Stack(
        children: [
          // Background Tech Constellations & Curved Node Grid
          Positioned.fill(
            child: CustomPaint(
              painter: FuturisticTechBackgroundPainter(),
            ),
          ),
          // Main Content Layer
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200), // Enforce high-end constrained width on large screens
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 1024;
                    return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Layout Desktop (Strictly Vertical flow: GreetingCard -> SectionTitleBanner (Quiz) -> RoadmapPath -> SectionTitleBanner (Ressources) -> Mediatheque) ---
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          GreetingCard(),
          SizedBox(height: 24),
          SectionTitleBanner(title: "Espace Interaction & Quiz (IA)"),
          SizedBox(height: 24),
          RoadmapPath(isDesktop: true), // Section 2 Content: Horizontal timeline stretched fully in the middle
          SizedBox(height: 24),
          SectionTitleBanner(title: "RESSOURCES & OUTILS"),
          SizedBox(height: 24),
          MediathequeSection(), // Section 1 Content: 3 white resource cards
        ],
      ),
    );
  }

  // --- Layout Mobile (Strictly Vertical flow: GreetingCard -> SectionTitleBanner (Quiz) -> RoadmapPath -> SectionTitleBanner (Ressources) -> Mediatheque) ---
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          GreetingCard(),
          SizedBox(height: 20),
          SectionTitleBanner(title: "Espace Interaction & Quiz (IA)"),
          SizedBox(height: 20),
          RoadmapPath(isDesktop: false), // Section 2 Content: Vertical timeline serpentine in the middle
          SizedBox(height: 20),
          SectionTitleBanner(title: "RESSOURCES & OUTILS"),
          SizedBox(height: 20),
          MediathequeSection(), // Section 1 Content: 3 white resource cards
        ],
      ),
    );
  }
}
