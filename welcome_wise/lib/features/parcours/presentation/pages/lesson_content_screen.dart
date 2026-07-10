import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../auth/presentation/bloc/login_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/futuristic_navbar.dart';
import '../widgets/futuristic_background.dart';

class LessonContentScreen extends StatefulWidget {
  final String lessonId;
  final String title;
  final bool playVideoImmediately;

  const LessonContentScreen({
    super.key,
    required this.lessonId,
    required this.title,
    this.playVideoImmediately = false,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _isPlaying = false;
  double _videoProgress = 0.6; // Started at 60% as seen in the mockup
  bool _notesSaved = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.playVideoImmediately;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _logout() {
    context.read<LoginBloc>().add(const LoginReset());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _saveNotes() {
    setState(() {
      _notesSaved = true;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notes enregistrées avec succès !"),
        backgroundColor: Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _simulateDownload(String filename) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Téléchargement de '$filename' démarré..."),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  // --- DESKTOP LAYOUT (Dual column 65% / 35%) ---
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (65%) - Video Player, Core Action Button, and Footer
        Expanded(
          flex: 65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVideoPlayerSection(),
              const SizedBox(height: 24),
              _buildCoreActionButton(),
              const SizedBox(height: 28),
              _buildFooterSection(),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right Column (35%) - Transcript, Notes, Attachments stacked vertically
        Expanded(
          flex: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTranscriptCard(),
              const SizedBox(height: 20),
              _buildNotesCard(),
              const SizedBox(height: 20),
              _buildAttachmentsCard(),
            ],
          ),
        ),
      ],
    );
  }

  // --- MOBILE LAYOUT (Single Vertical Column) ---
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildVideoPlayerSection(),
        const SizedBox(height: 20),
        _buildTranscriptCard(),
        const SizedBox(height: 20),
        _buildNotesCard(),
        const SizedBox(height: 20),
        _buildAttachmentsCard(),
        const SizedBox(height: 24),
        _buildCoreActionButton(),
        const SizedBox(height: 28),
        _buildFooterSection(),
      ],
    );
  }

  // --- 1. VIDEO PLAYER SECTION ---
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Cours : Leçon ${widget.lessonId} — ${widget.title}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.picture_in_picture_alt_rounded, size: 20, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          // Interactive AspectRatio video container
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Play / Pause Simulation overlay
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  // Progress and controls at the bottom of the video frame
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Custom slider track inside video frame
                          Row(
                            children: [
                              Text(
                                "05:12",
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 3,
                                    activeTrackColor: AppColors.gold,
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: AppColors.goldLight,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                                  ),
                                  child: Slider(
                                    value: _videoProgress,
                                    onChanged: (val) {
                                      setState(() {
                                        _videoProgress = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                "08:40",
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Control icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 20),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _isPlaying = !_isPlaying;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 20),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.volume_up_rounded, color: Colors.white, size: 16),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Meryem watched ${(_videoProgress * 100).toInt()}%",
                                    style: const TextStyle(color: Color(0xFFF5D878), fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. TRANSCRIPT CARD ---
  Widget _buildTranscriptCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.menu_book_rounded, color: Color(0xFF9E7E5D), size: 18),
              SizedBox(width: 10),
              Text(
                "Texte de la leçon (Transcript)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            "Règles strictes de manipulation des machines en usine :\n\n"
            "1. Avant toute mise en marche d'un équipement de production ou d'une ligne d'emballage chez Ménara Holding, assurez-vous systématiquement de porter l'intégralité de vos Équipements de Protection Individuelle (EPI). Ceci comprend obligatoirement le casque de sécurité ajusté, les lunettes de protection oculaire contre les projections, les gants renforcés anti-coupures, et vos chaussures de sécurité à embout d'acier.\n\n"
            "2. Procédez à une inspection pré-opérationnelle rigoureuse de la console de commande et des zones d'engrenage. Si vous observez le moindre câble dénudé, une fuite d'huile hydraulique ou un signal lumineux d'alerte, ne démarrez pas la machine. Informez immédiatement votre chef d'équipe ou le superviseur de maintenance de votre secteur.\n\n"
            "3. Il est strictement interdit d'intervenir à l'intérieur du châssis ou de nettoyer les cylindres rotatifs d'une machine en mouvement ou sous tension. Pour toute opération de nettoyage, de réglage ou de débourrage, vous devez appliquer rigoureusement la procédure de Consignation Industrielle (LOTO - Lockout/Tagout) en coupant l'alimentation électrique générale et en apposant votre cadenas personnel sur le sectionneur.\n\n"
            "4. Maintenez en permanence la zone entourant les machines propre et exempte de tout encombrement. Tout déversement de liquide ou de lubrifiant doit être nettoyé immédiatement pour prévenir les risques de glissade.\n\n"
            "5. En cas d'anomalie critique, de bruit anormal ou de situation d'urgence mettant en cause la sécurité, appuyez sur le bouton d'arrêt d'urgence rouge de type « coup de poing » situé au plus proche de votre poste. Ne relancez jamais la production sans le feu vert explicite de l'équipe de maintenance.",
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. NOTES CARD ---
  Widget _buildNotesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.edit_note_rounded, color: Color(0xFF9E7E5D), size: 20),
              SizedBox(width: 8),
              Text(
                "Notes de la leçon",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 4,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: "Saisissez vos notes personnelles ici...",
              hintStyle: const TextStyle(fontSize: 11, color: AppColors.textHint),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saveNotes,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9E7E5D), // Elegant warm brown
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Sauvegarder les notes",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. ATTACHMENTS/FILES CARD ---
  Widget _buildAttachmentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.attachment_rounded, color: Color(0xFF9E7E5D), size: 18),
              SizedBox(width: 8),
              Text(
                "Documents & Annexes (Files)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Attachment Item 1
          _buildFileRow(
            title: "Guide de manipulation (PDF)",
            subtitle: "1.8 Mo — Règles complètes",
            icon: Icons.picture_as_pdf_rounded,
            filename: "Guide_Manipulation_Securite.pdf",
          ),
          const SizedBox(height: 12),
          // Attachment Item 2
          _buildFileRow(
            title: "Photos des Machines (Image Set)",
            subtitle: "4.5 Mo — Schémas techniques",
            icon: Icons.image_rounded,
            filename: "Schema_Technique_Usines.zip",
          ),
        ],
      ),
    );
  }

  Widget _buildFileRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required String filename,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E7E5D), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Green download button
          InkWell(
            onTap: () => _simulateDownload(filename),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_downward_rounded,
                color: Color(0xFF2E7D32),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. CORE ACTION BUTTON ---
  Widget _buildCoreActionButton() {
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
                // Return true to the caller screen to indicate this lesson is completed
                Navigator.pop(context, true);
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "J'AI COMPRIS LA LEÇON",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            "Complétez cette leçon pour débloquer la suivante",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF0F172A), // Deep night blue for readability
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  // --- 6. FOOTER SECTION ---
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
