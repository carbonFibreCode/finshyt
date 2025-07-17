import 'dart:developer';

import 'package:finshyt/Features/homepage/presentation/cubits/homepage_cubit.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/constants/app_strings.dart';
import 'package:finshyt/Features/expense/presentation/add_expense_screen.dart';
import 'package:finshyt/Features/update_budget/presentation/update_budget_screen.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/widgets/common/custom_button.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _goToUpdateBudget(context),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: Size(176, 40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.check, color: AppColors.primary, size: 40),
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      AppStrings.updateBudget,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              text: 'Add Expense',
              textSize: 16,
              onPressed: () async {
                await Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddExpense()));
                final userId = context.read<AppUserCubit>().currentUser?.id;
                if (userId != null) {
                  context.read<HomepageCubit>().loadInsights(
                    userId,
                  ); // Force reload after add
                  log('Reloaded homepage after adding expense');
                }
              },
              bgcolor: AppColors.background,
              textColor: AppColors.primary,
              height: AppDimensions.smallBtnheight,
              width: AppDimensions.smallBtnWidth,
              borderRadius: AppDimensions.smallBtnBRadius,
              icon: Icons.add,
              iconColor: AppColors.primary,
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
      context.read<HomepageCubit>().loadInsights(
        userId,
      ); // Force reload after update budget
      log('Reloaded homepage after adding expense');
    
  }
}
