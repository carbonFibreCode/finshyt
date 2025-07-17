import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/presentation/cubits/insights_cubit.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/constants/app_text_styles.dart';
import 'package:finshyt/Features/insights/presentation/widgets/all_insights/insight_cards.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:finshyt/core/models/chart_data_models.dart';
import 'package:finshyt/Features/homepage/presentation/widgets/chart.dart';
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
            create: (_) => serviceLocator<InsightsCubit>()..fetchInsights(userId),
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
          return const Center(child: CircularProgressIndicator());
        }
        if (state is InsightsFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is InsightsLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.edgePadding),
            itemCount: 2 + state.insights.dailyGroups.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, idx) {
              if (idx == 0) {
                return Chart(
                  data: state.insights.chartData,
                  chartType: ChartType.doubleBar,
                  maxY: _maxY(state.insights.chartData),
                  title1: 'Spent',
                  title2: 'Budget',
                  primaryColor: AppColors.warnings,
                  secondaryColor: AppColors.secondary,
                );
              }
              if (idx == 1) {
                return InsightCards(insights: state.insights);
              }
              final g = state.insights.dailyGroups[idx - 2];
              return _DayTile(group: g);
            },
          );
        }
        return const Center(child: Text('No insights available'));
      },
    );
  }

  double _maxY(List<ChartData> d) =>
      d.fold(0.0, (m, c) => m < c.primaryValue ? c.primaryValue : m) + 20;
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
                title: Text(e.description), // Updated from 'purpose' to 'description' based on entity
                subtitle: Text(DateFormat.Hm().format(e.expenseDate)), // Updated from 'ts' to 'expenseDate'
                trailing: Text(e.amount.toStringAsFixed(0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
