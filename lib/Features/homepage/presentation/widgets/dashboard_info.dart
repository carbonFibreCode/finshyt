import 'dart:developer';

import 'package:finshyt/Features/homepage/presentation/cubits/homepage_cubit.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_strings.dart';
import 'package:finshyt/Features/expense/presentation/add_expense_screen.dart';
import 'package:finshyt/Features/update_budget/presentation/update_budget_screen.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardInfo extends StatelessWidget {
  final HomepageInsights insights;
  const DashboardInfo({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final totalBudget = insights.totalBudget;
    final balance = insights.balance;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.balance,
                  style: GoogleFonts.inter(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  balance.toStringAsFixed(0),
                  style: GoogleFonts.inter(
                    color: AppColors.background,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(width: 1, height: 68, color: AppColors.borders),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.monthlyBudget,
                  style: GoogleFonts.inter(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  totalBudget.toStringAsFixed(0),
                  style: GoogleFonts.inter(
                    color: AppColors.background,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                onPressed: () => _goToUpdateBudget(context),
                icon: Icons.check,
                label: 'Update Budget',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: _ActionButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddExpense()),
                  );
                  final userId = context.read<AppUserCubit>().currentUser?.id;
                  if (userId != null) {
                    context.read<HomepageCubit>().loadInsights(userId);
                  }
                },
                icon: Icons.add,
                label: 'Add Expense',
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _goToUpdateBudget(BuildContext context) async {
    final userState = context.read<AppUserCubit>().state;
    final messenger = ScaffoldMessenger.of(context);

    if (userState is! AppUserLoggedIn) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    final userId = userState.user.id;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => UpdateBudget(userId: userId)));
    context.read<HomepageCubit>().loadInsights(userId);
    log('Reloaded homepage after adding expense');
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
          )
        : OutlinedButton.styleFrom(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
          );

    final buttonContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );

    return isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: style.copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            child: buttonContent,
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: style.copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            child: buttonContent,
          );
  }
}
