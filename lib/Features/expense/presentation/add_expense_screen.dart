import 'dart:developer';
import 'package:finshyt/Features/expense/presentation/cubits/expense_cubit.dart';
import 'package:finshyt/Features/homepage/presentation/cubits/homepage_cubit.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/cubits/budget_cubit/active_budget_cubit.dart';
import 'package:finshyt/core/widgets/common/custom_button.dart';
import 'package:finshyt/core/widgets/common/custom_text_field.dart';
import 'package:finshyt/core/widgets/common/snackbar.dart';
import 'package:finshyt/features/expense/domain/usecases/add_expense.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Add Your Current Expense',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.background,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.edgePadding,
        ),
        child: BlocProvider(
          create: (_) => serviceLocator<ExpenseCubit>(),
          child: const _Form(),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final amountCtl = TextEditingController();
  final purposeCtl = TextEditingController();

  @override
  void dispose() {
    amountCtl.dispose();
    purposeCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseSuccess) {
          showSnackBar(context, 'Expense added successfully!');
          Navigator.of(context).pop();
        } else if (state is ExpenseFailure) {
          showSnackBar(context, 'Error: ${state.message}');
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did you spend wisely ?',
              style: GoogleFonts.inter(
                color: AppColors.background,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.edgePadding),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Amount Spent',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: amountCtl,
                      hintText: 'Enter the amount spent',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Purpose',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      controller: purposeCtl,
                      hintText: 'Purpose (Movies, shopping, grocery, etc.)',
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ExpenseCubit, ExpenseState>(
                      builder: (context, state) {
                        final isLoading = state is ExpenseLoading;
                        return CustomButton(
                          text: isLoading ? 'Adding...' : 'Add Expense',
                          onPressed: isLoading ? null : _submit,
                          bgcolor: AppColors.primary,
                          textColor: AppColors.background,
                          borderRadius: 16,
                          icon: Icons.money_sharp,
                          iconColor: AppColors.background,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    
    final user = context.read<AppUserCubit>().currentUser;
    if (user == null) {
      showSnackBar(context, 'You must be logged in to add an expense.');
      return;
    }

    final amt = double.tryParse(amountCtl.text.trim()) ?? 0;
    final prp = purposeCtl.text.trim();

    if (prp.isEmpty) {
      showSnackBar(context, 'Please enter the purpose');
    } else if (amt <= 0) {
      showSnackBar(context, 'Please enter a valid amount');
    } else {

      final currentBudgetId = context.read<ActiveBudgetCubit>().activeBudgetId;

      if (currentBudgetId == null) {
      }

      final params = AddExpenseParams(
        userId: user.id, 
        budgetId: currentBudgetId,
        amount: amt,
        description: prp,
        expenseDate: DateTime.now(),
      );
      context.read<ExpenseCubit>().addExpense(params);
      context.read<HomepageCubit>().loadInsights(user.id);
    }
  }
}
