import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/scholarship_application.dart';

// Horizontal progress line: Submitted -> Verified -> Sanctioned -> Disbursed.
// Current stage highlighted saffron, completed stages green, pending grey.
class ApplicationProgressStepper extends StatelessWidget {
  const ApplicationProgressStepper({
    super.key,
    required this.currentStage,
    this.actionRequired = false,
  });

  final ApplicationStage currentStage;

  // §1.1: when true, the CURRENT stage's dot renders red (alert state)
  // instead of saffron. No 5th step is added to the stepper.
  final bool actionRequired;

  static const List<String> _labels = [
    'Submitted',
    'Verified',
    'Sanctioned',
    'Disbursed',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = currentStage.index;

    return Row(
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isEven) {
          final stageIndex = i ~/ 2;
          final isDone = stageIndex < currentIndex;
          final isCurrent = stageIndex == currentIndex;
          final isAlert = isCurrent && actionRequired;
          final dotColor = isDone
              ? AppColors.green
              : (isAlert
                  ? const Color(0xFFD32F2F)
                  : (isCurrent ? AppColors.saffron : AppColors.border));

          return Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  border: isCurrent
                      ? Border.all(color: AppColors.navy, width: 1.5)
                      : null,
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 10, color: AppColors.white)
                    : (isAlert
                        ? const Icon(Icons.priority_high, size: 10, color: AppColors.white)
                        : null),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 62,
                child: Text(
                  _labels[stageIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isAlert
                        ? const Color(0xFFD32F2F)
                        : (isCurrent ? AppColors.saffron : AppColors.textDark),
                  ),
                ),
              ),
            ],
          );
        } else {
          final lineIndex = i ~/ 2;
          final isDone = lineIndex < currentIndex;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              height: 2,
              color: isDone ? AppColors.green : AppColors.border,
            ),
          );
        }
      }),
    );
  }
}