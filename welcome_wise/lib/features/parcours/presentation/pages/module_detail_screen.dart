import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../auth/presentation/bloc/login_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/futuristic_navbar.dart';
import '../widgets/futuristic_background.dart';
import 'lesson_content_screen.dart';
import 'quiz_play_screen.dart';

class ModuleDetailScreen extends StatefulWidget {
  const ModuleDetailScreen({super.key});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  // Lesson progression states
  LessonStatus _lesson21Status = LessonStatus.completed;
  LessonStatus _lesson22Status = LessonStatus.completed;
  LessonStatus _lesson23Status = LessonStatus.current;
  LessonStatus _lesson24Status = LessonStatus.locked;

  // Reset the BLoC state and redirect to LoginPage
  void _logout() {
    context.read<LoginBloc>().add(const LoginReset());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // Navigate to LessonContentScreen and wait for completion state
  void _handleSubAction(String number, String title, String actionName) async {
    print("WelcomeWise debug: Click detected on $number ($title) with action: $actionName");
    final playVideo = actionName == "Watch Offline";
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LessonContentScreen(
          lessonId: number,
          title: title,
          playVideoImmediately: playVideo,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        if (number == "2.3") {
          _lesson23Status = LessonStatus.completed;
          _lesson24Status = LessonStatus.current;
        } else if (number == "2.4") {
          _lesson24Status = LessonStatus.completed;
        }
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Félicitations ! Leçon $number complétée avec succès."),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCEB395), // Warm ocre/beige background matching the Dashboard
      appBar: FuturisticNavbar(
        onLogout: _logout,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Background Tech Constellations & Curved Node Grid
          Positioned.fill(
            child: CustomPaint(
              painter: FuturisticTechBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                final paddingHorizontal = isDesktop ? 32.0 : 16.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 24),
                      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (65%) - Video, Progress, AI Quiz, and Footer
        Expanded(
          flex: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVideoPlayerSection(),
              const SizedBox(height: 28),
              _buildProgressSection(),
              const SizedBox(height: 28),
              _buildAIQuizButton(),
              const SizedBox(height: 32),
              _buildFooterSection(),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right Column (35% - Sidebar) - Lessons list
        Expanded(
          flex: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  "LISTE DES LEÇONS (MODULE 2)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A), // Deep night blue for contrast on ocre background
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              LessonItemCard(
                number: "2.1",
                title: "Introduction à la sécurité",
                status: _lesson21Status,
                onSubActionTap: _handleSubAction,
              ),
              const SizedBox(height: 12),
              LessonItemCard(
                number: "2.2",
                title: "Équipements de protection individuelle",
                status: _lesson22Status,
                onSubActionTap: _handleSubAction,
              ),
              const SizedBox(height: 12),
              LessonItemCard(
                number: "2.3",
                title: "Manipulation des machines & usines",
                status: _lesson23Status,
                onSubActionTap: _handleSubAction,
              ),
              const SizedBox(height: 12),
              LessonItemCard(
                number: "2.4",
                title: "Consignes de sécurité internes & plans",
                status: _lesson24Status,
                onSubActionTap: _handleSubAction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. VIDEO & LEARNING CONTENT AREA
        _buildVideoPlayerSection(),
        const SizedBox(height: 28),

        // 2. MODULE LESSONS LIST TITLE
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "LISTE DES LEÇONS (MODULE 2)",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A), // Deep night blue for contrast on ocre background
              letterSpacing: 0.8,
            ),
          ),
        ),

        // Lessons Column
        LessonItemCard(
          number: "2.1",
          title: "Introduction à la sécurité",
          status: _lesson21Status,
          onSubActionTap: _handleSubAction,
        ),
        const SizedBox(height: 12),
        LessonItemCard(
          number: "2.2",
          title: "Équipements de protection individuelle",
          status: _lesson22Status,
          onSubActionTap: _handleSubAction,
        ),
        const SizedBox(height: 12),
        LessonItemCard(
          number: "2.3",
          title: "Manipulation des machines & usines",
          status: _lesson23Status,
          onSubActionTap: _handleSubAction,
        ),
        const SizedBox(height: 12),
        LessonItemCard(
          number: "2.4",
          title: "Consignes de sécurité internes & plans",
          status: _lesson24Status,
          onSubActionTap: _handleSubAction,
        ),
        const SizedBox(height: 32),

        // 3. GLOBAL PROGRESS INDICATOR
        _buildProgressSection(),
        const SizedBox(height: 28),

        // 4. AI QUIZ BUTTON
        _buildAIQuizButton(),
        const SizedBox(height: 32),

        // 5. FOOTER QUICK CONTACT ACTIONS
        _buildFooterSection(),
      ],
    );
  }


  // --- VIDEO PLAYER SIMULATION WIDGET ---
  Widget _buildVideoPlayerSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Vidéo Pédagogique : Règles de sécurité en usine",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Gradient video placeholder box
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEDFCE), Color(0xFFDCC8B4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Play button icon
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Color(0xFF9E7E5D),
                    size: 64,
                  ),
                  // Progress labels at the bottom of the video frame
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Visionné à 60%",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E563F),
                          ),
                        ),
                        Text(
                          "60%",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E563F),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Progress Slider simulation
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.gold,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: AppColors.goldDark,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: 0.6,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

// Extracted LessonItemCard class moved to the end of the file to fix code nesting.

  // --- PROGRESS SECTION ---
  Widget _buildProgressSection() {
    int completedCount = 0;
    if (_lesson21Status == LessonStatus.completed) completedCount++;
    if (_lesson22Status == LessonStatus.completed) completedCount++;
    if (_lesson23Status == LessonStatus.completed) completedCount++;
    if (_lesson24Status == LessonStatus.completed) completedCount++;

    final progressValue = completedCount / 4.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Progression du module",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                "$completedCount/4 Leçons complétées",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          )
        ],
      ),
    );
  }

  // --- PREMIUM AI QUIZ INITIATION BUTTON ---
  Widget _buildAIQuizButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4AF37), Color(0xFF2C3E50)], // Gold to Slate Tech gradient
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "LANCER LE QUIZ IA INTELLIGENT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.psychology, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            "Complétez toutes les leçons pour débloquer le Quiz",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF0F172A), // Deep night blue for readability
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  // --- FOOTER CONTACT LINK BUTTONS ---
  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ouverture du formulaire de contact RH...")),
            );
          },
          icon: const Icon(Icons.mail_outline_rounded, size: 16, color: Color(0xFF0F172A)),
          label: const Text(
            "Contacter RH",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ouverture de la discussion avec l'IA...")),
            );
          },
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF0F172A)),
          label: const Text(
            "Discuter avec l'IA",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}

// --- REUSABLE STATEFUL LESSON CARD WITH HOVER TRANSITIONS ---
class LessonItemCard extends StatefulWidget {
  final String number;
  final String title;
  final LessonStatus status;
  final Function(String number, String title, String action) onSubActionTap;

  const LessonItemCard({
    super.key,
    required this.number,
    required this.title,
    required this.status,
    required this.onSubActionTap,
  });

  @override
  State<LessonItemCard> createState() => _LessonItemCardState();
}

class _LessonItemCardState extends State<LessonItemCard> {
  bool _isHovered = false;
  bool _shouldShowButtons = false;

  @override
  Widget build(BuildContext context) {
    final isLocked = widget.status == LessonStatus.locked;
    final isCurrent = widget.status == LessonStatus.current;
    final isCompleted = widget.status == LessonStatus.completed;

    // Standard border color
    Color borderColor = isCurrent 
        ? AppColors.gold 
        : (isCompleted ? const Color(0xFF81C784).withOpacity(0.4) : Colors.grey.shade200);

    // Glowing gold border when hovered
    if (_isHovered && !isLocked) {
      borderColor = const Color(0xFFD4AF37); // Glow gold border
    }

    // Shadows
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(isLocked ? 0.01 : 0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      )
    ];

    if (_isHovered && !isLocked) {
      shadows = [
        BoxShadow(
          color: const Color(0xFFD4AF37).withOpacity(0.20), // Glowing gold tech lueur
          blurRadius: 18,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        )
      ];
    }

    Widget cardBody = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Left status indicator
              if (isCompleted)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18)
              else if (isCurrent)
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 10),
                  ),
                )
              else
                Icon(Icons.lock_outline_rounded, color: Colors.grey.shade400, size: 18),

              const SizedBox(width: 12),

              // Title Text
              Expanded(
                child: Text(
                  "${widget.number}  ${widget.title}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isLocked ? Colors.grey.shade500 : AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Right validation check (matches mockup visual markers)
              if (isCompleted)
                const Icon(Icons.check, color: Color(0xFF2E7D32), size: 14)
              else if (isCurrent)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),

          // Nested Action Sub-buttons (only for the active lesson) with Hover effect
          if (isCurrent)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isHovered ? 82.0 : 0.0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: Visibility(
                    visible: _shouldShowButtons,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSubActionButton(
                              icon: Icons.play_circle_outline_rounded,
                              label: "Watch Offline",
                              onTap: () => widget.onSubActionTap(widget.number, widget.title, "Watch Offline"),
                            ),
                            _buildSubActionButton(
                              icon: Icons.menu_book_outlined,
                              label: "Lire",
                              onTap: () => widget.onSubActionTap(widget.number, widget.title, "Lire"),
                            ),
                            _buildSubActionButton(
                              icon: Icons.headphones_outlined,
                              label: "Écouter",
                              onTap: () => widget.onSubActionTap(widget.number, widget.title, "Écouter"),
                            ),
                          ],
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

    // Inkwell wrap
    Widget innerContent = InkWell(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cette leçon est verrouillée. Veuillez compléter la leçon actuelle d'abord !"),
              backgroundColor: Color(0xFFEF5350),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          widget.onSubActionTap(widget.number, widget.title, "Card Tap");
        }
      },
      child: cardBody,
    );

    // MouseRegion for Hover effect
    Widget resultCard = MouseRegion(
      onEnter: (_) {
        if (!isLocked) {
          setState(() {
            _isHovered = true;
            _shouldShowButtons = true;
          });
        }
      },
      onExit: (_) {
        if (!isLocked) {
          setState(() {
            _isHovered = false;
          });
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && !_isHovered) {
              setState(() {
                _shouldShowButtons = false;
              });
            }
          });
        }
      },
      cursor: isLocked ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered 
            ? (Matrix4.identity()..translate(0.0, -5.0)) 
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey.shade100.withOpacity(0.8) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isCurrent || _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: innerContent,
          ),
        ),
      ),
    );

    return resultCard;
  }

  // --- LESSON CARD SUB-ACTION BUTTON ---
  Widget _buildSubActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF9E7E5D)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum LessonStatus {
  completed,
  current,
  locked,
}
