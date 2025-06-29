// lib/Features/home/presentation/home_page.dart
import 'package:finshyt/models/chart_data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/cubits/insights/insight_cubit.dart';
import 'package:finshyt/init_dependencies.dart';

import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/widgets/homepage/homepage_row.dart';
import 'package:finshyt/widgets/homepage/dashboard_info.dart';
import 'package:finshyt/widgets/homepage/chart.dart';

import 'package:finshyt/Features/expense/presentation/allInsights/all_insights.dart';
import 'package:finshyt/Features/expense/presentation/allInsights/widgets/all_insights/insight_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          LoadingScreen().show(context: context, text: 'Just a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      child: Builder(
        builder: (ctx) {
          final userId = ctx.read<AppUserCubit>().currentUser?.id;
          if (userId == null) {
            return const Scaffold(body: Center(child: Text('Please log in')));
          }

          return FutureBuilder<DateTime?>(
            future: _getLatestBudgetStartDate(userId),
            builder: (c, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final cycleStart = snap.data; 

              return BlocProvider<InsightsCubit>(
                create: (_) =>
                    serviceLocator<InsightsCubit>()
                      ..load(userId, startDate: cycleStart),
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.edgePadding,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const HomepageRow(),
                          const SizedBox(height: 0),
                          const DashboardInfo(),
                          const SizedBox(height: 20),


                          BlocBuilder<InsightsCubit, InsightsState>(
                            builder: (_, state) {
                              if (state is! InsightsLoaded) {
                                return const SizedBox(
                                  height: 220,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final chart = state.chart;
                              final maxY =
                                  chart.fold<double>(
                                    0,
                                    (m, c) =>
                                        m <
                                            (c.primaryValue >
                                                    (c.secondaryValue ?? 0)
                                                ? c.primaryValue
                                                : (c.secondaryValue ?? 0))
                                        ? (c.primaryValue >
                                                  (c.secondaryValue ?? 0)
                                              ? c.primaryValue
                                              : (c.secondaryValue ?? 0))
                                        : m,
                                  ) +
                                  20;

                              return Chart(
                                data: chart,
                                chartType: ChartType.doubleBar,
                                maxY: maxY,
                                title1: 'Spent',
                                title2: 'Budget',
                                primaryColor: AppColors.warnings,
                                secondaryColor: AppColors.secondary,
                              );
                            },
                          ),

                          const SizedBox(height: 8),


                          BlocBuilder<InsightsCubit, InsightsState>(
                            builder: (_, state) {
                              if (state is! InsightsLoaded) {
                                return const SizedBox();
                              }

                              final balance =
                                  state.totalBudget - state.totalSpent;
                              final avg = state.days.isEmpty
                                  ? 0.0
                                  : state.totalSpent / state.days.length;

                              return InsightCards(
                                mainTitle: 'Total Expense',
                                totalExpense: state.totalSpent,
                                balance: balance,
                                avgSpend: avg,
                                monthlyBudget: state.totalBudget,
                              );
                            },
                          ),

                          const SizedBox(height: 8),

                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AllInsights(),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.navigate_next_rounded,
                                  color: AppColors.background,
                                  size: 60,
                                ),
                                Text(
                                  'Show All Insights',
                                  style: GoogleFonts.inter(
                                    color: AppColors.background,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Future<DateTime?> _getLatestBudgetStartDate(String userId) async {
    final sb = serviceLocator<SupabaseClient>();


    final row = await sb
        .from('daily_budget')
        .select('date')
        .eq('user_id', userId)
        .order('date', ascending: true) 
        .limit(1)
        .maybeSingle();

    if (row == null) return null;

    return DateTime.parse(row['date'] as String);
  }
}
