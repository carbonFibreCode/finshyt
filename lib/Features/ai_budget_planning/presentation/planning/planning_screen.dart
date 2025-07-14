import 'dart:developer';
import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/generate_budget_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/save_budget_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubits/budget_planner_cubit.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/planning/widgets/day_insights.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/planning/widgets/month_insights.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/models/chart_data_models.dart';
import 'package:finshyt/core/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/Features/homepage/presentation/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({
    super.key,
    required this.userId,
    required this.monthlyBudget,
    required this.description,
    this.eventDate,
    this.city,
  });

  final String userId;
  final double monthlyBudget;
  final String description;
  final DateTime? eventDate;
  final String? city;

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the AI plan generation as soon as the screen loads.
    context.read<BudgetPlannerCubit>().generatePlan(
          GenerateBudgetPlanParams(
            monthlyBudget: widget.monthlyBudget,
            description: widget.description,
            eventDate: widget.eventDate,
            city: widget.city,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetPlannerCubit, BudgetPlannerState>(
      // This listener handles side effects like showing snackbars or navigating.
      listener: (context, state) {
        if (state is BudgetSaving) {
          LoadingScreen()
              .show(context: context, text: 'Saving Plan...');
        } else if (state is BudgetSaveSuccess) {
          LoadingScreen().hide();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Budget plan saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is BudgetPlannerFailure) {
            LoadingScreen().hide();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
        // The body now rebuilds based on the cubit's state.
        body: BlocBuilder<BudgetPlannerCubit, BudgetPlannerState>(
          builder: (context, state) {
            if (state is BudgetPlannerLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BudgetPlannerFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to generate plan: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (state is BudgetPlannerSuccess) {
              // Once the plan is successfully generated, display it.
              return _buildPlanContent(context, state.items);
            }
            // Initial state or other unhandled states.
            return const Center(
              child: Text('Generating your budget plan...'),
            );
          },
        ),
      ),
    );
  }

  // Extracted the main content into a separate method for clarity.
  Widget _buildPlanContent(BuildContext context, List<BudgetItem> planItems) {
    final bars = planItems
        .map((item) => ChartData(
              label: DateFormat('d').format(item.date),
              primaryValue: item.amount,
            ))
        .toList();
    final totalPlanned = planItems.fold<double>(0, (sum, item) => sum + item.amount);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.check),
        label: Text(
          'Approve & Save',
          style: GoogleFonts.inter(color: AppColors.background),
        ),
        onPressed: () {
          log('Clicked Approve and saved');
          context.read<BudgetPlannerCubit>().savePlan(
                SaveBudgetPlanParams(
                  userId: widget.userId,
                  startDate: planItems.first.date,
                  items: planItems,
                ),
              );
        },
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.edgePadding),
        itemCount: 2 + planItems.length,
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
          if (idx == 1) {
            return MonthInsight(
              total: totalPlanned,
              monthlyBudget: widget.monthlyBudget,
            );
          }
          final item = planItems[idx - 2];
          return DayInsight(item: item);
        },
      ),
    );
  }

  double _maxY(List<ChartData> d) =>
      d.fold(0.0, (m, c) => m < c.primaryValue ? c.primaryValue : m) + 20;
}