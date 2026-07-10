import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/onboarding_module.dart';
import '../pages/module_detail_screen.dart';
import '../pages/quiz_play_screen.dart';

class RoadmapPath extends StatelessWidget {
  final bool isDesktop;
  const RoadmapPath({super.key, required this.isDesktop});

  // Simplified domain module list frozen in professional French
  static List<OnboardingModule> defaultModules = [
    OnboardingModule(
      id: 1,
      titleKey: "Découverte du Groupe",
      subtitleKey: "Module 1",
      status: ModuleStatus.completed,
      items: [
        const OnboardingItem(icon: Icons.history, labelKey: "Histoire du Groupe"),
        const OnboardingItem(icon: Icons.handshake, labelKey: "Nos Valeurs"),
        const OnboardingItem(icon: Icons.business, labelKey: "Filiales du Groupe"),
      ],
    ),
    OnboardingModule(
      id: 2,
      titleKey: "Sécurité & Règlements",
      subtitleKey: "Module 2",
      status: ModuleStatus.current,
      items: [
        const OnboardingItem(icon: Icons.engineering, labelKey: "Équipements de protection"),
        const OnboardingItem(icon: Icons.domain, labelKey: "Visite du site / Usine"),
        const OnboardingItem(icon: Icons.assignment, labelKey: "Règles et consignes"),
      ],
    ),
    OnboardingModule(
      id: 3,
      titleKey: "Métier",
      subtitleKey: "Module 3",
      status: ModuleStatus.locked,
      items: [
        const OnboardingItem(icon: Icons.build, labelKey: "Outils de travail"),
        const OnboardingItem(icon: Icons.person, labelKey: "Missions du poste"),
        const OnboardingItem(icon: Icons.play_circle_outline, labelKey: "Vidéo de présentation"),
      ],
    ),
  ];

  // Additional simulated modules for the popup/modal
  static final List<OnboardingModule> allModules = [
    ...defaultModules,
    OnboardingModule(
      id: 4,
      titleKey: "Missions & Objectifs",
      subtitleKey: "Module 4",
      status: ModuleStatus.locked,
      items: [
        const OnboardingItem(icon: Icons.flag, labelKey: "Objectifs du trimestre"),
        const OnboardingItem(icon: Icons.groups, labelKey: "Présentation de l'équipe"),
        const OnboardingItem(icon: Icons.feedback, labelKey: "Session d'alignement"),
      ],
    ),
    OnboardingModule(
      id: 5,
      titleKey: "Évaluation Finale",
      subtitleKey: "Module 5",
      status: ModuleStatus.locked,
      items: [
        const OnboardingItem(icon: Icons.assignment_turned_in, labelKey: "Rapport d'intégration"),
        const OnboardingItem(icon: Icons.rate_review, labelKey: "Feedback Manager & RH"),
        const OnboardingItem(icon: Icons.stars, labelKey: "Certification de réussite"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Pure white for a stunning relief effect against the blue-grey page background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Centered Header "Mon Parcours d'Intégration"
          const Center(
            child: Text(
              "Mon Parcours d'Intégration",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Adaptive Layout
          isDesktop ? _buildDesktopRoadmap(context, defaultModules) : _buildMobileRoadmap(context, defaultModules),
        ],
      ),
    );
  }

  // --- 1. MOBILE VERTICAL ROADMAP (Wavy Serpentine Curve) ---
  Widget _buildMobileRoadmap(BuildContext context, List<OnboardingModule> modules) {
    final mod1 = modules.firstWhere((m) => m.id == 1);
    final mod2 = modules.firstWhere((m) => m.id == 2);
    final mod3 = modules.firstWhere((m) => m.id == 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 800.0; // Stretched height for vertical progression

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Custom Paint Background for connection road (with dotted network patterns)
              Positioned.fill(
                child: CustomPaint(
                  painter: _MobileRoadPainter(width: width, height: height),
                ),
              ),

              // Module 1 Card: Top Left
              Positioned(
                top: 10,
                left: 20,
                width: 170,
                child: _buildModuleCard(context, mod1),
              ),

              // Module 2 Card: Middle Upper Right (Current)
              Positioned(
                top: 190,
                right: 20,
                width: 190,
                child: _buildModuleCard(context, mod2),
              ),

              // Module 3 Card: Middle Lower Left (Locked)
              Positioned(
                top: 480,
                left: 20,
                width: 170,
                child: _buildModuleCard(context, mod3),
              ),

              // "Voir plus" Premium Card: Bottom Right
              Positioned(
                top: 660,
                right: 20,
                width: 170,
                height: 120,
                child: _buildVoirPlusCard(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 2. DESKTOP HORIZONTAL ROADMAP ---
  Widget _buildDesktopRoadmap(BuildContext context, List<OnboardingModule> modules) {
    final mod1 = modules.firstWhere((m) => m.id == 1);
    final mod2 = modules.firstWhere((m) => m.id == 2);
    final mod3 = modules.firstWhere((m) => m.id == 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 500.0; // Increased height to prevent any overflow on Desktop

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Custom Paint Background for connection road (with dotted network patterns)
              Positioned.fill(
                child: CustomPaint(
                  painter: _DesktopRoadPainter(width: width, height: height),
                ),
              ),

              // Module 1: Left
              Positioned(
                top: 40,
                left: 15,
                width: 170,
                child: _buildModuleCard(context, mod1),
              ),

              // Module 2: Center-Left (Current)
              Positioned(
                top: 90,
                left: width * 0.28,
                width: 200,
                child: _buildModuleCard(context, mod2),
              ),

              // Module 3: Center-Right (Locked)
              Positioned(
                top: 40,
                left: width * 0.60,
                width: 170,
                child: _buildModuleCard(context, mod3),
              ),

              // "Voir plus" Premium Card: Right
              Positioned(
                top: 40,
                right: 15,
                width: 100,
                height: 180,
                child: _buildVoirPlusCard(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 3. REUSABLE MODULE CARD BUILDER ---
  Widget _buildModuleCard(BuildContext context, OnboardingModule module) {
    Color cardBgColor;
    Color borderColor;
    Color titleColor;
    Color subtitleColor;
    Color iconColor;
    Color textColor;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (module.status) {
      case ModuleStatus.completed:
        cardBgColor = const Color(0xFFE8F5E9); // Soft green
        borderColor = AppColors.success.withOpacity(0.5);
        titleColor = const Color(0xFF1B5E20);
        subtitleColor = const Color(0xFF2E7D32);
        iconColor = const Color(0xFF2E7D32);
        textColor = const Color(0xFF37474F);
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = "Validé";
        break;
      case ModuleStatus.current:
        cardBgColor = Colors.white;
        borderColor = AppColors.gold;
        titleColor = AppColors.textPrimary;
        subtitleColor = AppColors.goldDark;
        iconColor = AppColors.textSecondary;
        textColor = AppColors.textSecondary;
        statusColor = AppColors.primaryBlue;
        statusIcon = Icons.radio_button_checked;
        statusText = "En cours";
        break;
      case ModuleStatus.locked:
        cardBgColor = Colors.grey.shade50;
        borderColor = Colors.grey.shade300;
        titleColor = Colors.grey.shade500;
        subtitleColor = Colors.grey.shade400;
        iconColor = Colors.grey.shade400;
        textColor = Colors.grey.shade400;
        statusColor = Colors.grey;
        statusIcon = Icons.lock;
        statusText = "Verrouillé";
        break;
    }

    final isLocked = module.status == ModuleStatus.locked;
    final isCurrent = module.status == ModuleStatus.current;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top clickable info area
              InkWell(
                onTap: () => _handleModuleTap(context, module),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Module Pill
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isLocked 
                                ? Colors.grey.shade200 
                                : (module.status == ModuleStatus.completed 
                                    ? Colors.green.shade100 
                                    : AppColors.gold.withOpacity(0.15)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            module.subtitleKey,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isLocked 
                                  ? Colors.grey 
                                  : (module.status == ModuleStatus.completed 
                                      ? Colors.green.shade800 
                                      : AppColors.goldDark),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        module.titleKey,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Status Row
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      // Sub-items list
                      ...module.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                Icon(item.icon, size: 12, color: iconColor),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.labelKey,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              
              // Non-clickable bottom action area containing child clickable buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // If Active/Current Module, embed the AI Quiz Button & Safety Badge
                    if (isCurrent) ...[
                      _buildAIQuizButton(context),
                      const SizedBox(height: 8),
                      _buildBadgeWidget(),
                    ],

                    // Bottom Videos & Tools Text
                    if (module.id > 1) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "Ressources & Outils",
                          style: TextStyle(
                            fontSize: 8,
                            color: isLocked ? Colors.grey.shade400 : AppColors.textHint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 4. PREMIUM "VOIR PLUS" CARD ---
  Widget _buildVoirPlusCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAllModulesPopup(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gold Gradient plus circular icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.goldGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Voir plus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tous les modules",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Handle Click Actions based on module status ---
  void _handleModuleTap(BuildContext context, OnboardingModule module) {
    String msg;
    IconData icon;
    Color color;

    switch (module.status) {
      case ModuleStatus.completed:
        msg = "Vous avez déjà validé le module ${module.titleKey} !";
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case ModuleStatus.current:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ModuleDetailScreen()),
        );
        return;
      case ModuleStatus.locked:
        msg = "Ce module est verrouillé. Veuillez d'abord valider le module précédent !";
        icon = Icons.lock;
        color = Colors.red;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- OpenAI Quiz Button (with flexible layout to prevent overflows) ---
  Widget _buildAIQuizButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Flexible padding, NO fixed height on parent
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "PASSEZ VOTRE QUIZ (IA)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.psychology, color: AppColors.gold, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Badge Widget ---
  Widget _buildBadgeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield, color: AppColors.gold, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Badge Expert Sécurité",
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  "Ressources & Outils",
                  style: TextStyle(
                    fontSize: 6,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- POPUP / DIALOG: ALL ONBOARDING MODULES TIMELINE LIST ---
  void _showAllModulesPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 20,
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 650),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Premium Gold Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border(
                      bottom: BorderSide(color: AppColors.gold.withOpacity(0.4), width: 2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Mon Parcours d'Intégration",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Suivez l'avancement de vos étapes d'intégration",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFBDC3C7),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),

                // Timeline List of Modules
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: allModules.length,
                    itemBuilder: (context, index) {
                      final module = allModules[index];
                      
                      Color accentColor;
                      IconData indicatorIcon;
                      bool isCurrent = module.status == ModuleStatus.current;
                      bool isCompleted = module.status == ModuleStatus.completed;

                      if (isCompleted) {
                        accentColor = const Color(0xFF2E7D32); // Premium green
                        indicatorIcon = Icons.check_circle_rounded;
                      } else if (isCurrent) {
                        accentColor = AppColors.gold;
                        indicatorIcon = Icons.play_circle_filled_rounded;
                      } else {
                        accentColor = Colors.grey.shade400;
                        indicatorIcon = Icons.lock_outline_rounded;
                      }

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline visual line and indicator
                            Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isCurrent ? Colors.white : accentColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accentColor,
                                      width: isCurrent ? 2.5 : 1.5,
                                    ),
                                    boxShadow: isCurrent ? [
                                      BoxShadow(
                                        color: AppColors.gold.withOpacity(0.3),
                                        blurRadius: 6,
                                      )
                                    ] : null,
                                  ),
                                  child: Icon(
                                    indicatorIcon,
                                    color: accentColor,
                                    size: 16,
                                  ),
                                ),
                                if (index < allModules.length - 1)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade200,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Module Card details in popup
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isCompleted 
                                        ? const Color(0xFFE8F5E9).withOpacity(0.3) 
                                        : (isCurrent ? Colors.white : Colors.grey.shade50),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isCurrent 
                                          ? AppColors.gold 
                                          : (isCompleted ? const Color(0xFF81C784).withOpacity(0.4) : Colors.grey.shade200),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            module.subtitleKey.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: isCurrent ? AppColors.goldDark : AppColors.textHint,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: accentColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              isCompleted ? "VALIDÉ" : (isCurrent ? "EN COURS" : "VERROUILLÉ"),
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: accentColor,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        module.titleKey,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrent ? AppColors.textPrimary : Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(height: 12),
                                      // Render list items inline
                                      ...module.items.map((item) => Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              module.status == ModuleStatus.locked ? Icons.lock_outline : item.icon,
                                              size: 12,
                                              color: isCurrent ? AppColors.textSecondary : Colors.grey.shade400,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                item.labelKey,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: isCurrent ? AppColors.textSecondary : Colors.grey.shade400,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- 5. CUSTOM PATH PAINTERS WITH DOTTED NETWORK PATTERNS ---

// Mobile Path Painter (Zigzag Z-shape path: Module 1 -> Module 2 -> Module 3 -> Voir Plus)
class _MobileRoadPainter extends CustomPainter {
  final double width;
  final double height;
  _MobileRoadPainter({required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle grid network dots behind the road
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.12)
      ..strokeWidth = 1.5;
    
    const double step = 24.0;
    for (double x = 0; x < width; x += step) {
      for (double y = 0; y < height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, gridPaint);
      }
    }

    final roadBackgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    final activeRoadPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.green.shade400,
          AppColors.gold,
          AppColors.goldDark,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Center coordinates matching the mobile layout positions
    final p1 = Offset(20 + 170 / 2, 90);               // Module 1 (Completed, top-left)
    final p2 = Offset(width - 20 - 190 / 2, 325);       // Module 2 (Current, middle-upper-right)
    final p3 = Offset(20 + 170 / 2, 560);               // Module 3 (Locked, middle-lower-left)
    final p4 = Offset(width - 20 - 170 / 2, 720);       // "Voir plus" (Locked, bottom-right)

    // Segment 1 (Active): From Module 1 to Module 2.
    // Clean serpentine vertical path flowing smoothly from left to right
    final pathActive = Path()..moveTo(p1.dx, p1.dy);
    pathActive.cubicTo(
      width * 0.2, p1.dy + 80,
      width * 0.8, p2.dy - 80,
      p2.dx, p2.dy,
    );

    // Segment 2 (Inactive): From Module 2 to Module 3.
    // Serpentine path flowing smoothly from right to left
    final pathInactive1 = Path()..moveTo(p2.dx, p2.dy);
    pathInactive1.cubicTo(
      width * 0.8, p2.dy + 80,
      width * 0.2, p3.dy - 80,
      p3.dx, p3.dy,
    );

    // Segment 3 (Inactive): From Module 3 to Voir plus.
    // Serpentine path flowing smoothly from left to right
    final pathInactive2 = Path()..moveTo(p3.dx, p3.dy);
    pathInactive2.cubicTo(
      width * 0.2, p3.dy + 80,
      width * 0.8, p4.dy - 80,
      p4.dx, p4.dy,
    );

    // Draw background roads
    canvas.drawPath(pathActive, roadBackgroundPaint);
    canvas.drawPath(pathInactive1, roadBackgroundPaint);
    canvas.drawPath(pathInactive2, roadBackgroundPaint);

    // Draw active road highlight
    canvas.drawPath(pathActive, activeRoadPaint);

    // Draw center dotted lanes
    final dashActivePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dashInactivePaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, pathActive, dashActivePaint, 8.0, 6.0);
    _drawDashedPath(canvas, pathInactive1, dashInactivePaint, 8.0, 6.0);
    _drawDashedPath(canvas, pathInactive2, dashInactivePaint, 8.0, 6.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double nextDistance = distance + dashLength;
        final Path extract = metric.extractPath(
          distance,
          nextDistance < metric.length ? nextDistance : metric.length,
        );
        canvas.drawPath(extract, paint);
        distance = nextDistance + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Desktop Path Painter (Wavy horizontal path: Module 1 -> Module 2 -> Module 3 -> Voir Plus)
class _DesktopRoadPainter extends CustomPainter {
  final double width;
  final double height;
  _DesktopRoadPainter({required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle grid network dots behind the road
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.12)
      ..strokeWidth = 1.5;
    
    const double step = 24.0;
    for (double x = 0; x < width; x += step) {
      for (double y = 0; y < height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, gridPaint);
      }
    }

    final roadBackgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    final activeRoadPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.green.shade400,
          AppColors.gold,
          AppColors.goldDark,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Center coordinates on desktop
    final p1 = Offset(15 + 170 / 2, 125);              // Module 1 (Left)
    final p2 = Offset(width * 0.28 + 200 / 2, 220);    // Module 2 (Center)
    final p3 = Offset(width * 0.60 + 170 / 2, 130);    // Module 3 (Right)
    final p4 = Offset(width - 15 - 100 / 2, 130);      // "Voir plus" (Far Right)

    // Segment 1 (Active): Module 1 to Module 2
    final pathActive = Path()..moveTo(p1.dx, p1.dy);
    pathActive.quadraticBezierTo(width * 0.22, 215, p2.dx, p2.dy);

    // Segment 2 (Inactive): Module 2 to Module 3
    final pathInactive1 = Path()..moveTo(p2.dx, p2.dy);
    pathInactive1.quadraticBezierTo(width * 0.50, 215, p3.dx, p3.dy);

    // Segment 3 (Inactive): Module 3 to Voir Plus card
    final pathInactive2 = Path()..moveTo(p3.dx, p3.dy);
    pathInactive2.quadraticBezierTo(width * 0.85, 110, p4.dx, p4.dy);

    // Draw background roads
    canvas.drawPath(pathActive, roadBackgroundPaint);
    canvas.drawPath(pathInactive1, roadBackgroundPaint);
    canvas.drawPath(pathInactive2, roadBackgroundPaint);

    // Draw active road
    canvas.drawPath(pathActive, activeRoadPaint);

    // Draw center dotted lanes
    final dashActivePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final dashInactivePaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, pathActive, dashActivePaint, 8.0, 6.0);
    _drawDashedPath(canvas, pathInactive1, dashInactivePaint, 8.0, 6.0);
    _drawDashedPath(canvas, pathInactive2, dashInactivePaint, 8.0, 6.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double nextDistance = distance + dashLength;
        final Path extract = metric.extractPath(
          distance,
          nextDistance < metric.length ? nextDistance : metric.length,
        );
        canvas.drawPath(extract, paint);
        distance = nextDistance + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
