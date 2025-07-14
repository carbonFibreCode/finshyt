import 'package:finshyt/Features/ai_budget_planning/presentation/planning/widgets/progress_bar.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class MonthInsight extends StatelessWidget {
  const MonthInsight({required this.total, required this.monthlyBudget});
  final double total;
  final double monthlyBudget;

  @override
  Widget build(BuildContext context) {
    final bal = monthlyBudget - total;
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pair('Total Planned', total.toStringAsFixed(0)),
          const SizedBox(height: 4),
          _pair('Balance', bal.toStringAsFixed(0)),
          const SizedBox(height: 4),
          _pair('Avg / Day', (total / 30).toStringAsFixed(0)),
          const Spacer(),
          ProgressBar(total: total, monthly: monthlyBudget),
        ],
      ),
    );
  }

  Widget _pair(String l, String v) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(v),
        ],
      );
}
