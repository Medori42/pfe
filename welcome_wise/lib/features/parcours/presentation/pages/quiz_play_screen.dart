import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../auth/presentation/bloc/login_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/futuristic_background.dart';
import 'quiz_result_screen.dart';

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String aiHint;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.aiHint,
  });
}

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  final List<int> _userAnswers = [];
  bool _isNextHovered = false;
  int _points = 35;
  bool _showAiHint = false;
  
  // Timer state
  Timer? _countdownTimer;
  int _secondsLeft = 12;
  static const int _totalSeconds = 15;

  // 10 HSE safety questions
  static const List<QuizQuestion> _questions = [
    QuizQuestion(
      questionText: "Quel équipement est obligatoire pour accéder à la zone de production principale ?",
      options: [
        "Lunettes de protection seulement",
        "Casque + chaussures de sécurité + lunettes",
        "Gants de protection thermique",
        "Aucun équipement requis"
      ],
      correctOptionIndex: 1,
      explanation: "Les Équipements de Protection Individuelle (EPI) de base (casque, chaussures renforcées, lunettes) sont obligatoires dans toute zone industrielle.",
      aiHint: "Indice de l'IA : Le casque protège la tête, les chaussures protègent les pieds et les lunettes protègent les yeux. Cherchez la combinaison complète.",
    ),
    QuizQuestion(
      questionText: "En cas d'alarme incendie dans l'usine, quelle est la première action à effectuer ?",
      options: [
        "Finir sa tâche en cours rapidement",
        "Appeler immédiatement son manager",
        "Prendre ses effets personnels",
        "Se diriger calmement vers le point de rassemblement"
      ],
      correctOptionIndex: 3,
      explanation: "La sécurité avant tout : évacuez immédiatement par l'issue de secours la plus proche sans paniquer ni vous arrêter pour récupérer des affaires.",
      aiHint: "Indice de l'IA : Ne perdez pas de temps à rassembler des affaires ou appeler. La priorité absolue est de quitter la zone vers le point de rassemblement.",
    ),
    QuizQuestion(
      questionText: "Que signifie le marquage au sol rouge et blanc zébré ?",
      options: [
        "Emplacement dédié aux machines",
        "Zone piétonne autorisée",
        "Zone d'accès libre (extincteurs, issues de secours)",
        "Zone de chargement temporaire"
      ],
      correctOptionIndex: 2,
      explanation: "Les zones rayées rouge et blanc indiquent l'obligation de laisser l'accès libre (issues de secours, extincteurs).",
      aiHint: "Indice de l'IA : Ce marquage indique des zones de sécurité critique (extincteurs, issues) qui doivent rester libres de tout obstacle en permanence.",
    ),
    QuizQuestion(
      questionText: "Quelle est la durée maximale de validité d'une autorisation de travail à chaud (permis de feu) ?",
      options: [
        "1 journée de travail",
        "1 semaine entière",
        "1 mois d'activité",
        "Durée illimitée"
      ],
      correctOptionIndex: 0,
      explanation: "Le permis de feu est délivré pour une tâche spécifique et une durée limitée, généralement une seule journée de travail.",
      aiHint: "Indice de l'IA : Les risques d'incendie varient chaque jour. L'autorisation doit être renouvelée quotidiennement pour chaque poste.",
    ),
    QuizQuestion(
      questionText: "En cas de déversement chimique accidentel, que devez-vous faire en premier ?",
      options: [
        "Ignorer le déversement et le laisser sécher",
        "Sécuriser la zone et utiliser le kit antipollution adapté",
        "Jeter de l'eau claire dessus",
        "Nettoyer avec vos vêtements de rechange"
      ],
      correctOptionIndex: 1,
      explanation: "Sécurisez d'abord la zone pour éviter tout contact direct, puis appliquez l'absorbant du kit antipollution.",
      aiHint: "Indice de l'IA : Ne diluez jamais le produit chimique avec de l'eau. Sécurisez la zone et utilisez un kit absorbant.",
    ),
    QuizQuestion(
      questionText: "Qui devez-vous contacter en priorité pour signaler un presque-accident ?",
      options: [
        "Le responsable HSE ou votre superviseur direct",
        "Le service informatique",
        "Le PDG du groupe",
        "Les ressources humaines"
      ],
      correctOptionIndex: 0,
      explanation: "Votre superviseur direct et l'équipe HSE sont formés pour enregistrer et corriger immédiatement les risques potentiels.",
      aiHint: "Indice de l'IA : Le superviseur direct et le responsable HSE sont les plus aptes à corriger immédiatement les risques opérationnels.",
    ),
    QuizQuestion(
      questionText: "Quel type d'extincteur doit être utilisé sur un feu électrique ?",
      options: [
        "Un seau d'eau",
        "Extincteur à eau pure",
        "Extincteur à CO2 ou à poudre",
        "Extincteur à eau avec additif"
      ],
      correctOptionIndex: 2,
      explanation: "L'eau conduit l'électricité. Il faut utiliser un agent non conducteur comme le CO2 ou la poudre chimique sèche.",
      aiHint: "Indice de l'IA : L'eau conduit l'électricité et aggrave le risque d'électrocution. Utilisez un extincteur à CO2.",
    ),
    QuizQuestion(
      questionText: "Quelle est la règle d'or pour le levage manuel d'une charge lourde ?",
      options: [
        "Porter la charge à bout de bras",
        "Fléchir les genoux et garder le dos droit",
        "Plier le dos en gardant les jambes tendues",
        "Soulever d'un coup sec"
      ],
      correctOptionIndex: 1,
      explanation: "Garder le dos droit et utiliser la force des jambes prévient les risques de blessures lombaires graves.",
      aiHint: "Indice de l'IA : Pour préserver votre colonne vertébrale, pliez toujours vos jambes et gardez le dos bien droit durant l'effort.",
    ),
    QuizQuestion(
      questionText: "Quel comportement est proscrit lors d'une visite de l'usine ?",
      options: [
        "Poser des questions au guide",
        "Suivre les allées piétonnes vertes",
        "Prendre des photos et s'écarter du tracé",
        "Porter les EPI requis"
      ],
      correctOptionIndex: 2,
      explanation: "Pour des raisons de sécurité et de confidentialité, les photos sont interdites et les visiteurs doivent suivre le guide.",
      aiHint: "Indice de l'IA : Les photos non autorisées compromettent le secret industriel et s'écarter du tracé piéton est extrêmement dangereux.",
    ),
    QuizQuestion(
      questionText: "Quelle est la signification du pictogramme Point d'Exclamation Rouge ?",
      options: [
        "Produit inflammable",
        "Danger de mort immédiat",
        "Produit irritant, nocif ou sensibilisant",
        "Substance corrosive"
      ],
      correctOptionIndex: 2,
      explanation: "Ce pictogramme signale des produits chimiques qui présentent des risques d'irritation cutanée ou de toxicité moyenne.",
      aiHint: "Indice de l'IA : Ce symbole est utilisé pour les produits nocifs, irritants ou sensibilisants qui nécessitent des précautions standards.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _secondsLeft = _totalSeconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _countdownTimer?.cancel();
      }
    });
  }

  void _logout() {
    context.read<LoginBloc>().add(const LoginReset());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _handleNextQuestion() {
    if (_selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner une option avant de continuer !"),
          backgroundColor: Color(0xFFEF5350),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check correctness and update score/points
    if (_selectedOptionIndex == _questions[_currentQuestionIndex].correctOptionIndex) {
      setState(() {
        _points += 10;
      });
    }

    _userAnswers.add(_selectedOptionIndex!);

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _showAiHint = false;
      });
      _startTimer();
    } else {
      _countdownTimer?.cancel();
      
      // Calculate score
      int score = 0;
      for (int i = 0; i < _questions.length; i++) {
        if (_userAnswers[i] == _questions[i].correctOptionIndex) {
          score++;
        }
      }

      // Extract raw data lists to pass to result screen
      final questionsText = _questions.map((q) => q.questionText).toList();
      final allAnswers = _questions.map((q) => q.options).toList();
      final correctIndices = _questions.map((q) => q.correctOptionIndex).toList();
      final explanations = _questions.map((q) => q.explanation).toList();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: score,
            totalQuestions: _questions.length,
            userAnswers: _userAnswers,
            questionsText: questionsText,
            allAnswers: allAnswers,
            correctIndices: correctIndices,
            explanations: explanations,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCEB395), // Warm ocre/beige background
      body: Stack(
        children: [
          // Background Tech Painter
          Positioned.fill(
            child: CustomPaint(
              painter: FuturisticTechBackgroundPainter(),
            ),
          ),
          
          // Main Scroll View holding the centered card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias, // Clip header background to card border radius
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(),
                            _buildQuestionSection(),
                            if (_showAiHint && _selectedOptionIndex != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: _buildInlineSpeechBubble(),
                              ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: _buildNextButton(),
                            ),
                            const SizedBox(height: 24),
                            _buildFooter(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Clean Web back button on top-left of the screen
          _buildDesktopBackButton(),
        ],
      ),
    );
  }

  Widget _buildDesktopBackButton() {
    return Positioned(
      top: 16,
      left: 16,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: Color(0xFF475569)),
              SizedBox(width: 8),
              Text(
                "Retour",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE7DEC8), // Beige sand background
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        children: [
          // Profile Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
                  ),
                  backgroundColor: Color(0xFFC9A84C),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Meryem FATHI",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4A3E3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3-Block Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Card: Progress info
              Expanded(
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5DEC9).withOpacity(0.8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Leçon 2.3",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9E7E5D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Quest. ${_currentQuestionIndex + 1}/${_questions.length}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Center Card: Animated Timer
              CircularTimer(
                secondsLeft: _secondsLeft,
                totalSeconds: _totalSeconds,
              ),
              const SizedBox(width: 12),

              // Right Card: Score Points
              Expanded(
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5DEC9).withOpacity(0.8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Points",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9E7E5D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$_points Pts",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFFD4AF37),
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection() {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      color: Colors.white,
      child: Column(
        children: [
          // Centered AI Question Text
          Text(
            currentQuestion.questionText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          
          // Discrete sub-text
          const Text(
            "Question générée par l'IA basée sur la vidéo",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 28),

          // 4 Options
          ...List.generate(currentQuestion.options.length, (idx) {
            final isSelected = _selectedOptionIndex == idx;
            return _buildOptionTile(idx, currentQuestion.options[idx], isSelected);
          }),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int idx, String optionText, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Option capsule
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFF8F5F0), // Royal Blue / Beige clair
              borderRadius: BorderRadius.circular(30), // perfect capsule
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFFFD700).withOpacity(0.8)
                    : const Color(0xFFE5DEC9).withOpacity(0.6),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.5), // gold glow
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.4), // cyan glow
                        blurRadius: 12,
                        spreadRadius: -1,
                      ),
                    ]
                  : [],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedOptionIndex = idx;
                  _showAiHint = false;
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Option prefix (A, B, C, D)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + idx), // A, B, C, D
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Option text aligned to the LEFT
                  Expanded(
                    child: Text(
                      optionText,
                      textAlign: TextAlign.left, // Left-aligned
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Floating AI button
          if (isSelected)
            Positioned(
              right: -12,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showAiHint = !_showAiHint;
                  });
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E293B),
                    border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFFD700),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInlineSpeechBubble() {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Align triangle to the right near the AI icon
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: CustomPaint(
              painter: TrianglePainter(),
              size: const Size(16, 10),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: Color(0xFFFFD700), size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Indice de l'IA :",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentQuestion.aiHint,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
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
              colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.5), // Electric Cyan glow
                blurRadius: _isNextHovered ? 20 : 12,
                spreadRadius: _isNextHovered ? 3 : 1,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF1D4ED8).withOpacity(0.4),
                blurRadius: _isNextHovered ? 20 : 12,
                spreadRadius: _isNextHovered ? 3 : 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleNextQuestion,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? "TERMINER LE QUIZ"
                          : "QUESTION SUIVANTE",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contact RH : rh@menaraholding.ma"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                "Contacter RH",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFC9A84C),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Redirection vers l'IA de discussion..."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                "Discuter avec l'IA",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFC9A84C),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Ménara Holding © 2026.",
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class CircularTimer extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const CircularTimer({
    Key? key,
    required this.secondsLeft,
    required this.totalSeconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = secondsLeft / totalSeconds;
    final glowColor = secondsLeft > 4 ? const Color(0xFF3B82F6) : Colors.red;
    final progressColor = secondsLeft > 4 ? const Color(0xFFD4AF37) : Colors.red;

    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 66,
            height: 66,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Reste",
                style: TextStyle(
                  fontSize: 8,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${secondsLeft}s",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              Icon(
                Icons.timer_outlined,
                size: 8,
                color: progressColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    // Triangle pointing UP
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
    
    final borderPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
