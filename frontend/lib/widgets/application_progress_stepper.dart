import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/scholarship_application.dart';

// Horizontal progress line: Submitted -> Verified -> Sanctioned -> Disbursed.
// Current stage highlighted saffron, completed stages green, pending grey.
class ApplicationProgressStepper extends StatelessWidget {
  const ApplicationProgressStepper({super.key, required this.currentStage});

  final ApplicationStage currentStage;

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
          final dotColor = isDone
              ? AppColors.green
              : (isCurrent ? AppColors.saffron : AppColors.border);

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
                    : null,
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
                    color: isCurrent ? AppColors.saffron : AppColors.textDark,
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