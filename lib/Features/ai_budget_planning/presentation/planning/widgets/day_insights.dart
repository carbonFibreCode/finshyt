import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayInsight extends StatelessWidget {
  const DayInsight({required this.item});
  final BudgetItem item; // Changed from PlanItem to BudgetItem

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, d MMM').format(item.date);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
          ),
          Text(item.amount.toStringAsFixed(0), style: AppTextStyles.cardTitle),
        ],
      ),
    );
  }
}
