import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/constants/app_text_styles.dart';
import 'package:finshyt/Features/expense/domain/models/expense_models.dart';
import 'package:finshyt/Features/expense/presentation/allInsights/widgets/all_insights/insight_cards.dart';
import 'package:finshyt/core/cubits/insights/insight_cubit.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:finshyt/models/chart_data_models.dart';
import 'package:finshyt/widgets/homepage/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllInsights extends StatelessWidget {
  const AllInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.background),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.primary,
        title: Text(
          'All Insights',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) {
          final userId = ctx.read<AppUserCubit>().currentUser?.id;
          if (userId == null) {
            return const Center(child: Text('Please log in first'));
          }

          return BlocProvider(
            create: (_) => serviceLocator<InsightsCubit>()..load(userId), 
            child: const _InsightsBody(),
          );
        },
      ),
    );
  }
}

class _InsightsBody extends StatelessWidget {
  const _InsightsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsCubit, InsightsState>(
      builder: (context, state) {
        if (state is InsightsLoading) {
          return const Center(child: CircularProgressIndicator(
            color: AppColors.background,
            
          ));
        }
        if (state is InsightsFailure) {
          return Center(child: Text(state.msg));
        }

        final s = state as InsightsLoaded;

        return ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.edgePadding),
          itemCount: 2 + s.days.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, idx) {
            if (idx == 0) {
              return Chart(
                data: s.chart,
                chartType: ChartType.doubleBar,
                maxY: _maxY(s.chart),
                title1: 'Spent',
                title2: 'Budget',
                primaryColor: AppColors.warnings,
                secondaryColor: AppColors.secondary,
              );
            }

            if (idx == 1) {
              final balance = s.totalBudget - s.totalSpent;
              final avgPerDay = s.days.isEmpty ? 0.0 : s.totalSpent / s.days.length;

              return InsightCards(
                mainTitle: 'Total Expense',
                totalExpense: s.totalSpent,
                balance: balance,
                avgSpend: avgPerDay,
                monthlyBudget: s.totalBudget,
              );
            }

            final g = s.days[idx - 2];
            return _DayTile(group: g);
          },
        );
      },
    );
  }

  double _maxY(List<ChartData> d) =>
      d.fold<double>(0, (m, c) => m < c.primaryValue ? c.primaryValue : m) + 20;
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.group});
  final DailyExpenseGroup group;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, d MMM').format(group.date);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text(
                dateLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                group.total.toStringAsFixed(0),
                style: AppTextStyles.cardTitle,
              ),
            ),
            const Divider(height: 0),
            ...group.items.map(
              (e) => ListTile(
                dense: true,
                title: Text(e.purpose),
                subtitle: Text(DateFormat.Hm().format(e.ts)),
                trailing: Text(e.amount.toStringAsFixed(0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
