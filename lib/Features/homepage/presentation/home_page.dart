import 'dart:developer';

import 'package:finshyt/Features/homepage/presentation/cubits/homepage_cubit.dart';
import 'package:finshyt/Features/homepage/presentation/widgets/dashboard_info.dart';
import 'package:finshyt/Features/homepage/presentation/widgets/homepage_insight_cards.dart';
import 'package:finshyt/Features/insights/presentation/all_insights.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/models/chart_data_models.dart';
import 'package:finshyt/features/homepage/presentation/widgets/chart.dart';
import 'package:finshyt/features/homepage/presentation/widgets/homepage_row.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasLoaded = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.watch<AppUserCubit>().currentUser?.id;
    if (userId != null && mounted && !_hasLoaded) {
      context.read<HomepageCubit>().loadInsights(userId);
      log('Reloaded homepage insights on dependency change'); 
      _hasLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AppUserCubit>().currentUser?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to continue.')),
      );
    }

    return BlocProvider<HomepageCubit>(
      create: (_) => serviceLocator<HomepageCubit>()..loadInsights(userId),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomepageCubit>().loadInsights(userId);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const HomepageRow(),
                  const SizedBox(height: 16),
                  BlocBuilder<HomepageCubit, HomepageState>(
                    builder: (context, state) {
                      if (state is HomepageLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is HomepageFailure) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      if (state is HomepageLoaded) {
                        return Column(
                          children: [
                            DashboardInfo(insights: state.insights),
                            const SizedBox(height: 20),
                            Chart(
                              data: state.insights.chartData,
                              chartType: ChartType.doubleBar,
                              maxY: _getMaxY(state.insights.chartData),
                              title1: 'Spent',
                              title2: 'Budget',
                              primaryColor: AppColors.warnings,
                            ),
                            const SizedBox(height: 8),
                            InsightCards(insights: state.insights),
                          ],
                        );
                      }
                      return const Center(child: Text('No data available.'));
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => const AllInsights(),));
                    },
                    icon: Icon(
                      Icons.chevron_right_sharp,
                      color: AppColors.background,
                      size: 36,
                    ),
                  ),
                  Text(
                    "Show All Insights",
                    style: GoogleFonts.inter(color: AppColors.background),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY(List<ChartData> data) {
    if (data.isEmpty) return 20;
    return data.fold<double>(0.0, (max, item) {
          final currentMax = item.primaryValue > (item.secondaryValue ?? 0)
              ? item.primaryValue
              : (item.secondaryValue ?? 0);
          return currentMax > max ? currentMax : max;
        }) +
        20;
  }
}
