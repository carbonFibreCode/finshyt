import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_dimensions.dart';
import 'package:finshyt/constants/app_strings.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/cubits/insights/insight_cubit.dart';
import 'package:finshyt/screens/Add&update/add_expense.dart';
import 'package:finshyt/screens/update_budget/update_budget_screen.dart';
import 'package:finshyt/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardInfo extends StatelessWidget {
  const DashboardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<InsightsCubit>().state;
    double totalBudget = 0;
    double balance = 0;

    if (st is InsightsLoaded) {
      totalBudget = st.totalBudget;
      balance = st.totalBudget - st.totalSpent;
    }

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
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                fixedSize: Size(176, 40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.check, color: AppColors.primary, weight: 40),
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
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddExpense()));
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
    final insightsCubit = context.read<InsightsCubit?>();
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

    if (!context.mounted) return;

    insightsCubit?.load(userId);
  }
}
