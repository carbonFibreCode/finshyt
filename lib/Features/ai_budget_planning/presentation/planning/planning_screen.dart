import 'package:finshyt/Features/ai_budget_planning/presentation/cubit/budget_save_cubit.dart';
import 'package:finshyt/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/constants/app_text_styles.dart';
import 'package:finshyt/init_dependencies.dart';

import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/widgets/homepage/chart.dart';
import 'package:finshyt/models/chart_data_models.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({
    super.key,
    required this.userId,
    required this.plan,
    required this.monthlyBudget,
    required this.description,
    required this.eventDate,
    required this.city,
  });

  final String userId;
  final BudgetPlan plan;
  final double monthlyBudget;
  final String description;
  final DateTime? eventDate;
  final String? city;

  @override
  Widget build(BuildContext context) {
//transform AI payload → chart & sums 
    final bars = plan.items
        .map<ChartData>(
          (p) => ChartData(
            label: DateFormat('d').format(p.date),
            primaryValue: p.amount,
          ),
        )
        .toList();

    final totalPlanned = plan.items.fold<double>(0, (t, p) => t + p.amount);

    return BlocProvider(
      create: (_) => serviceLocator<BudgetSaveCubit>(),
      child: BlocListener<BudgetSaveCubit, BudgetSaveState>(
        listener: (ctx, s) {
          if (s is BudgetSaveSuccess) {
            LoadingScreen().hide();
            Navigator.of(ctx).pop();
            showSnackBar(context, 'Budget Approved, check your balance');
          }
          if (s is BudgetSaveLoading) {
            LoadingScreen().show(context: context, text: 'Saving Budget');
          }
          if (s is BudgetSaveFailure) showSnackBar(context, 'Budget Saving Failed');
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              'AI Daily Budget',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.background,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.background,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          floatingActionButton: Builder(
            builder: (ctx) => FloatingActionButton.extended(
              backgroundColor: AppColors.secondary,
              icon: const Icon(Icons.check),
              label: Text(
                'Approve & Save',
                style: GoogleFonts.inter(color: AppColors.background),
              ),
              onPressed: () => ctx.read<BudgetSaveCubit>().savePlan(
                userId: userId,
                dailyBudget: monthlyBudget,
                plan: plan,
              ),
            ),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.edgePadding),
            itemCount: 2 + plan.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, idx) {

              if (idx == 0) {
                return Chart(
                  data: bars,
                  chartType: ChartType.singleBar, 
                  maxY: _maxY(bars),
                  title1: 'Daily Budget',
                  primaryColor: AppColors.secondary,
                );
              }

              /* 1 ▸ summary card (month) */
              if (idx == 1) {
                return _MonthInsight(
                  total: totalPlanned,
                  monthlyBudget: monthlyBudget,
                );
              }

              /* 2… ▸ card per day */
              final item = plan.items[idx - 2];
              return _DayInsight(item: item);
            },
          ),
        ),
      ),
    );
  }

  double _maxY(List<ChartData> d) =>
      d.fold(0.0, (m, c) => m < c.primaryValue ? c.primaryValue : m) + 20;


}

/*─────────────────── cards ───────────────────*/

class _MonthInsight extends StatelessWidget {
  const _MonthInsight({required this.total, required this.monthlyBudget});
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
          _ProgressBar(total: total, monthly: monthlyBudget),
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.total, required this.monthly});
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

class _DayInsight extends StatelessWidget {
  const _DayInsight({required this.item});
  final PlanItem item;

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
