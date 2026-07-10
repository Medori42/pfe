import 'package:flutter/widgets.dart';

enum ModuleStatus { completed, current, locked }

class OnboardingItem {
  final IconData icon;
  final String labelKey;

  const OnboardingItem({
    required this.icon,
    required this.labelKey,
  });
}

class OnboardingModule {
  final int id;
  final String titleKey;
  final String subtitleKey;
  final ModuleStatus status;
  final List<OnboardingItem> items;

  const OnboardingModule({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.status,
    required this.items,
  });

  bool get isCompleted => status == ModuleStatus.completed;
  bool get isCurrent => status == ModuleStatus.current;
  bool get isLocked => status == ModuleStatus.locked;
}
