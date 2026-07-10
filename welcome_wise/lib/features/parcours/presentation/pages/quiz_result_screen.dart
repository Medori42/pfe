import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/futuristic_navbar.dart';
import '../widgets/futuristic_background.dart';
import '../widgets/roadmap_path.dart';
import '../../domain/entities/onboarding_module.dart';
import 'parcours_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'quiz_play_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<int> userAnswers;
  final List<String> questionsText;
  final List<List<String>> allAnswers;
  final List<int> correctIndices;
  final List<String> explanations;
  final bool isSuccess;

  QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.questionsText,
    required this.allAnswers,
    required this.correctIndices,
    required this.explanations,
  }) : isSuccess = score >= 8;

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isNextHovered = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    final double targetPercentage = widget.score / widget.totalQuestions;
    _progressAnimation = Tween<double>(begin: 0.0, end: targetPercentage).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _handleGoToNextModule() {
    // 1. Update module 2 status to completed
    final idxM2 = RoadmapPath.defaultModules.indexWhere((m) => m.id == 2);
    if (idxM2 != -1) {
      final m2 = RoadmapPath.defaultModules[idxM2];
      RoadmapPath.defaultModules[idxM2] = OnboardingModule(
        id: m2.id,
        titleKey: m2.titleKey,
        subtitleKey: m2.subtitleKey,
        status: ModuleStatus.completed,
        items: m2.items,
      );
    }

    // 2. Update module 3 status to current (unlocked)
    final idxM3 = RoadmapPath.defaultModules.indexWhere((m) => m.id == 3);
    if (idxM3 != -1) {
      final m3 = RoadmapPath.defaultModules[idxM3];
      RoadmapPath.defaultModules[idxM3] = OnboardingModule(
        id: m3.id,
        titleKey: m3.titleKey,
        subtitleKey: m3.subtitleKey,
        status: ModuleStatus.current,
        items: m3.items,
      );
    }

    // 3. Clear stack and return to ParcoursPage (Dashboard)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ParcoursPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double percentageValue = (widget.score / widget.totalQuestions) * 100;
    final bool isSuccess = widget.isSuccess;

    return Scaffold(
      backgroundColor: const Color(0xFFCEB395),
      appBar: FuturisticNavbar(
        onLogout: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        showBackButton: false,
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600), // Center card maxWidth 600
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Banner Header (Gold/Ocre for success, Anthracite for failure)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        decoration: BoxDecoration(
                          color: isSuccess ? null : const Color(0xFF334155),
                          gradient: isSuccess
                              ? const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFC5A028)], // Premium Gold
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isSuccess ? "Félicitations, Meryem !" : "Désolé, Meryem !",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      // Central Content Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Animated Progress Ring Score
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Confetti sparkles background (only on success!)
                                  if (isSuccess)
                                    CustomPaint(
                                      size: const Size(220, 220),
                                      painter: _ConfettiPainter(),
                                    ),
                                  // Animated Progress Ring
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        size: const Size(160, 160),
                                        painter: _CircleProgressPainter(
                                          progress: _progressAnimation.value,
                                          isSuccess: isSuccess,
                                        ),
                                      );
                                    },
                                  ),
                                  // Score text
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${widget.score}/${widget.totalQuestions}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${percentageValue.toInt()}%",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                isSuccess ? "Quiz complété avec succès !" : "Le score requis de 80% n'a pas été atteint.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(height: 1),
                            const SizedBox(height: 24),

                            // 2. Badge Status Area (Gold badge or Locked badge)
                            Center(
                              child: Column(
                                children: [
                                  isSuccess ? _buildGoldBadge() : _buildLockedBadge(),
                                  const SizedBox(height: 12),
                                  Text(
                                    isSuccess ? "Niveau obtenu : Expert en Sécurité" : "Badge non obtenu (Requis: 8/10)",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isSuccess ? const Color(0xFF8A6D2C) : const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isSuccess
                                        ? "Vous avez répondu correctement à ${widget.score} questions sur ${widget.totalQuestions}. Votre badge a été ajouté à votre profil d'intégration."
                                        : "Tu as répondu correctement à ${widget.score} questions sur ${widget.totalQuestions}. Tu dois obtenir 80% ou plus pour progresser.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // 3. Main Action Button (Passer au module suivant OR Recommencer)
                            isSuccess ? _buildNextModuleButton() : _buildReplayButton(),
                            const SizedBox(height: 24),

                            // 4. Collapsible Review Answers Section
                            Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                leading: const Icon(Icons.rate_review_outlined, color: Color(0xFFD4AF37)),
                                title: const Text(
                                  "Revoir les réponses",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                children: List.generate(widget.questionsText.length, (index) {
                                  final questionText = widget.questionsText[index];
                                  final answersList = widget.allAnswers[index];
                                  final userAnswerIdx = widget.userAnswers[index];
                                  final correctAnswerIdx = widget.correctIndices[index];
                                  final explanation = widget.explanations[index];

                                  final bool isUserCorrect = userAnswerIdx == correctAnswerIdx;

                                  return Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Question Title
                                        Text(
                                          "Q${index + 1} : $questionText",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // User Answer Card
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: isUserCorrect
                                                ? const Color(0xFF2E7D32).withOpacity(0.08)
                                                : const Color(0xFFC62828).withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isUserCorrect
                                                  ? const Color(0xFF2E7D32).withOpacity(0.3)
                                                  : const Color(0xFFC62828).withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                isUserCorrect ? Icons.check_circle_outline : Icons.error_outline_rounded,
                                                color: isUserCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  "Votre réponse : ${answersList[userAnswerIdx]}",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isUserCorrect ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Correct Answer Card (only if user was incorrect)
                                        if (!isUserCorrect) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2E7D32).withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: const Color(0xFF2E7D32).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Color(0xFF2E7D32),
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Réponse correcte : ${answersList[correctAnswerIdx]}",
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF1B5E20),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],

                                        const SizedBox(height: 10),
                                        // Explanation
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFCEB395).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xFFCEB395).withOpacity(0.3), width: 0.5),
                                          ),
                                          child: Text(
                                            explanation,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF6D4C41),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Footer Links (Ask HR / Ask Chatbot)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Demande envoyée aux Ressources Humaines..."),
                                  backgroundColor: AppColors.primaryBlue,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF0F172A), size: 16),
                            label: const Text(
                              "Contacter RH",
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Discussion avec l'IA démarrée..."),
                                  backgroundColor: AppColors.primaryBlue,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0F172A), size: 16),
                            label: const Text(
                              "Discuter avec l'IA",
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Ménara Holding © 2026.",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
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

  Widget _buildGoldBadge() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFFFF8E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Laurier background vector
          Positioned(
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 84,
              color: const Color(0xFFD4AF37).withOpacity(0.9),
            ),
          ),
          // Inner safety helmet
          Positioned(
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFD4AF37),
              child: const Icon(
                Icons.engineering_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.star, size: 8, color: Colors.white),
                SizedBox(width: 4),
                Icon(Icons.star, size: 10, color: Colors.white),
                SizedBox(width: 4),
                Icon(Icons.star, size: 8, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedBadge() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF1F5F9),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.lock_outline,
          size: 48,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildNextModuleButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isNextHovered = true),
      onExit: (_) => setState(() => _isNextHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isNextHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC9A84C), Color(0xFF1E40AF)], // Gold to blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withOpacity(0.4),
                blurRadius: _isNextHovered ? 20 : 12,
                spreadRadius: _isNextHovered ? 3 : 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleGoToNextModule,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    const Text(
                      "PASSER AU MODULE SUIVANT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD4AF37), // Golden circle
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReplayButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isNextHovered = true),
      onExit: (_) => setState(() => _isNextHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isNextHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF64748B), // Slate gray matte
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isNextHovered ? 0.2 : 0.1),
                blurRadius: _isNextHovered ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, color: Colors.white, size: 20), // Icons.refresh as requested
                  SizedBox(width: 10),
                  Text(
                    "RECOMMENCER LE QUIZ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
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

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final bool isSuccess;

  _CircleProgressPainter({required this.progress, required this.isSuccess});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 8;

    // 1. Draw backing track
    final Paint trackPaint = Paint()
      ..color = isSuccess
          ? const Color(0xFF0F172A).withOpacity(0.08)
          : const Color(0xFFE65100).withOpacity(0.08)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw outer progress path
    final Paint progressPaintOuter = Paint()
      ..color = isSuccess ? const Color(0xFFD4AF37) : const Color(0xFFE64A19)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final double sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaintOuter,
    );

    // 3. Draw inner progress path
    final Paint progressPaintInner = Paint()
      ..color = isSuccess
          ? const Color(0xFF0288D1).withOpacity(0.7)
          : const Color(0xFFFFB74D).withOpacity(0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaintInner,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isSuccess != isSuccess;
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final random = math.Random(42);

    final colors = [
      const Color(0xFF0288D1),
      const Color(0xFFD4AF37),
      const Color(0xFFE64A19),
    ];

    for (int i = 0; i < 20; i++) {
      final double angle = (i * 18 * math.pi) / 180;
      final double distance = 84.0 + random.nextDouble() * 20.0;
      final double x = center + distance * math.cos(angle);
      final double y = center + distance * math.sin(angle);

      final paint = Paint()..color = colors[random.nextInt(colors.length)];
      final double size = 3 + random.nextDouble() * 4.0;

      if (i % 2 == 0) {
        final path = Path()
          ..moveTo(x, y - size)
          ..lineTo(x - size, y + size)
          ..lineTo(x + size, y + size)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(Offset(x, y), size / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => false;
}
