import 'dart:developer';

import 'package:finshyt/Features/ai_budget_planning/presentation/planning/planning_screen.dart';
import 'package:finshyt/Features/update_budget/presentation/services/location_service.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/widgets/common/custom_button.dart';
import 'package:finshyt/core/widgets/common/custom_text_field.dart';
import 'package:finshyt/core/widgets/common/snackbar.dart';

class UpdateBudget extends StatelessWidget {
  const UpdateBudget({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.background,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Update Monthly Budget',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.background,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.edgePadding,
        ),
        child: SingleChildScrollView(child: _Form(userId: userId)),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({required this.userId});

  final String userId;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final budgetCtl = TextEditingController();
  final descriptionCtl = TextEditingController();
  DateTime? eventDate;
  String? city;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final res = await LocationService.getCity();
    setState(() => city = res?.city ?? 'Unknown');
  }

  @override
  void dispose() {
    budgetCtl.dispose();
    descriptionCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.5,
      child: Column(
        children: [
          Text(
            'Plan your month wisely',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.background,
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
                  _label('Monthly Budget'),
                  CustomTextField(
                    controller: budgetCtl,
                    keyboardType: TextInputType.number,
                    hintText: 'Enter your monthly budget',
                  ),
                  const SizedBox(height: 16),
                  _label('Description / Major spends'),
                  CustomTextField(
                    controller: descriptionCtl,
                    hintText: 'e.g., Vacation, rent …',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _label('Important Event Date'),
                  InkWell(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.cardRadius,
                    ),
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                      ),
                      child: Text(
                        eventDate == null
                            ? 'Select date'
                            : '${eventDate!.day}-${eventDate!.month}-${eventDate!.year}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label('Location'),
                  Text(
                    city ?? 'Fetching...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save Budget',
                    bgcolor: AppColors.primary,
                    textColor: AppColors.background,
                    borderRadius: 16,
                    icon: Icons.save,
                    iconColor: AppColors.background,
                    onPressed: () => _submit(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _label(String text) => Text(
    text,
    style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: eventDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => eventDate = picked);
  }

  void _submit(BuildContext context) {
    final amount = double.tryParse(budgetCtl.text.trim()) ?? 0;
    final desc = descriptionCtl.text.trim();

    if (amount <= 0) {
      showSnackBar(context, 'Enter a valid budget amount');
      return;
    }
    if (eventDate == null) {
      showSnackBar(context, 'Select an event date');
      return;
    }
    if (city == null) {
      showSnackBar(context, 'Location not available');
      return;
    }

    log(
      'Saving budget: $amount, Description: $desc, Date: $eventDate, City: $city',
    );

    // Redirect to PlanningScreen, passing data
    final userId = context.read<AppUserCubit>().currentUser?.id;
    if (userId == null)
      showSnackBar(context, "Login to save Budget");
    else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlanningScreen(
            userId: userId,
            monthlyBudget: amount,
            description: desc,
            eventDate: eventDate!,
            city: city!,
          ),
        ),
      );
    }
  }
}
