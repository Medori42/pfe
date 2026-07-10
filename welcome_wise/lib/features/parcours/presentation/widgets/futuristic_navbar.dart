import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../pages/personal_profile_screen.dart';

class FuturisticNavbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;
  final bool showBackButton;
  
  const FuturisticNavbar({
    super.key,
    required this.onLogout,
    this.showBackButton = false,
  });

  @override
  State<FuturisticNavbar> createState() => _FuturisticNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _FuturisticNavbarState extends State<FuturisticNavbar> {
  bool _isGearHovered = false;
  bool _isLogoutHovered = false;
  bool _isNotificationHovered = false;

  @override
  Widget build(BuildContext context) {
    // Dynamic padding for desktop vs mobile
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingHorizontal = screenWidth >= 1024 ? 32.0 : 16.0;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      decoration: BoxDecoration(
        // Solid deep night blue/slate Slate 900 background for a premium futuristic dark theme
        color: const Color(0xFF0F172A),
        border: Border(
          bottom: BorderSide(
            color: Colors.cyan.withOpacity(0.4), // Futuristic cyan neon glow line
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2), // Neon tech glow shadow
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr, // Force Left-to-Right layout to prevent RTL flipping
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT: BackButton (optional) + Logo & AppName
              Row(
                children: [
                  if (widget.showBackButton && Navigator.canPop(context)) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37), size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2), // Slight padding to make the logo look premium
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryBlue,
                            child: const Center(
                              child: Text(
                                'W',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "WelcomeWise",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Pure white text for dark theme
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              // RIGHT: Settings & Logout
              Row(
                children: [
                  // Notification Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isNotificationHovered = true),
                    onExit: (_) => setState(() => _isNotificationHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isNotificationHovered 
                            ? Colors.cyan.withOpacity(0.15) 
                            : Colors.transparent,
                        boxShadow: _isNotificationHovered ? [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 12,
                          )
                        ] : null,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none_rounded,
                              color: _isNotificationHovered ? Colors.cyan : Colors.white.withOpacity(0.8),
                              size: 24,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Vous avez 2 nouvelles notifications d'intégration !"),
                                  backgroundColor: Color(0xFF0F172A),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            tooltip: "Notifications",
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Gear/Settings Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isGearHovered = true),
                    onExit: (_) => setState(() => _isGearHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isGearHovered 
                            ? const Color(0xFFD4AF37).withOpacity(0.15) 
                            : Colors.transparent,
                        boxShadow: _isGearHovered ? [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                            blurRadius: 12,
                          )
                        ] : null,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: _isGearHovered ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withOpacity(0.8),
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PersonalProfileScreen()),
                          );
                        },
                        tooltip: "Paramètres",
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Logout Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isLogoutHovered = true),
                    onExit: (_) => setState(() => _isLogoutHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isLogoutHovered 
                            ? const Color(0xFFEF4444).withOpacity(0.15) 
                            : Colors.transparent,
                        boxShadow: _isLogoutHovered ? [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                            blurRadius: 12,
                          )
                        ] : null,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: _isLogoutHovered ? const Color(0xFFEF4444) : Colors.white,
                          size: 24,
                        ),
                        onPressed: widget.onLogout,
                        tooltip: "Se déconnecter",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
