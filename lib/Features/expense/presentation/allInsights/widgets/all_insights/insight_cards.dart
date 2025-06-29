import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightCards extends StatelessWidget {
  const InsightCards({
    super.key,
    required this.mainTitle,
    required this.totalExpense,
    required this.balance,
    required this.avgSpend,
    required this.monthlyBudget,
  });

  final String  mainTitle;
  final double  totalExpense;
  final double  balance;
  final double  avgSpend;
  final double  monthlyBudget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          _row(mainTitle, totalExpense.toStringAsFixed(0)),
          _row(AppStrings.balance, balance.toStringAsFixed(0)),
          _row(AppStrings.avgSpendPerDay, avgSpend.toStringAsFixed(0)),
          if (monthlyBudget > 0) _indicator(),          // avoid NaN
        ],
      ),
    );
  }

  Widget _row(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l,
                style: GoogleFonts.inter(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            Text(v,
                style: GoogleFonts.inter(color: AppColors.text, fontSize: 12)),
          ],
        ),
      );

  Widget _indicator() {
    final ratio = (totalExpense / monthlyBudget).clamp(0.0, 1.0);
    final pct   = (ratio * 100).round();
    final over  = totalExpense - monthlyBudget;

    final barColor =
        ratio > 1   ? AppColors.warnings
        : ratio > .75 ? AppColors.warnings
        : ratio > .5  ? Colors.orange
        : AppColors.secondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget usage',
                  style: GoogleFonts.inter(
                      color: AppColors.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text('$pct %',
                  style: GoogleFonts.inter(
                      color: barColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppColors.secondaryText.withOpacity(.2),
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            over > 0
                ? 'Over budget by ${over.toStringAsFixed(0)}'
                : 'You can still spend ${(monthlyBudget - totalExpense).toStringAsFixed(0)}',
            style: GoogleFonts.inter(
                color: over > 0 ? Colors.red : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
