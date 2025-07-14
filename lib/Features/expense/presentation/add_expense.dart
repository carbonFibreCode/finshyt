import 'dart:developer';

import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:finshyt/core/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/core/widgets/common/custom_button.dart';
import 'package:finshyt/core/widgets/common/custom_text_field.dart';
import 'package:finshyt/core/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.background,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.edgePadding,
        ),
        child: SingleChildScrollView(child: _Form()),
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
    return Center(
      heightFactor: 2,
      child: Column(
        children: [
          Text(
            'Did you spend wisely ?',
            style: GoogleFonts.inter(
              color: AppColors.background,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 28),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.edgePadding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Amount Spent',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextField(
                    controller: amountCtl,
                    hintText: 'Enter the amount spent',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Purpose',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  CustomTextField(
                    controller: purposeCtl,
                    hintText:
                        'Purpose (Movies, shopping, grocery, travelling etc.)',
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    text: 'Add Expense',
                    onPressed: () {
                      //validation
                      final amt = double.tryParse(amountCtl.text) ?? 0;
                      final prp = purposeCtl.text.trim();
                      if (amt == 0 && prp.isEmpty) {
                        showSnackBar(context, 'Nothing to Submit');
                      } else if (prp.isEmpty) {
                        showSnackBar(context, 'Enter the purpose');
                      } else if (amt == 0) {
                        showSnackBar(context, 'Enter the Amount');
                      } else {
                        log('clicked Add expenses');
                      }
                    },
                    bgcolor: AppColors.primary,
                    textColor: AppColors.background,
                    borderRadius: 16,
                    icon: Icons.money_sharp,
                    iconColor: AppColors.background,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
