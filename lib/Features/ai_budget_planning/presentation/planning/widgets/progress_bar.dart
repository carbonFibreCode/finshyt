import 'package:finshyt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.total, required this.monthly});
  final double total;
  final double monthly;

  @override
  Widget build(BuildContext context) {
    final pct = (total / monthly).clamp(0.0, 1.0);
    return Column(
      children: [
        LinearProgressIndicator(
          value: pct,
          backgroundColor: AppColors.secondaryText.withOpacity(.2),
          valueColor: AlwaysStoppedAnimation(AppColors.secondary),
        ),
        const SizedBox(height: 6),
        Text(
          '${(pct * 100).toInt()} %',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}