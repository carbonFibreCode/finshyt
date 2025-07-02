import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_strings.dart';
import 'package:finshyt/constants/app_text_styles.dart';
import 'package:finshyt/Features/auth/presentation/screens/auth/auth_screen.dart';
import 'package:finshyt/utility/dialogs/showErrorDialog.dart';
import 'package:finshyt/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordCard extends StatefulWidget {
  const ForgotPasswordCard({super.key});

  @override
  State<ForgotPasswordCard> createState() => ForgotPasswordCardState();
}

class ForgotPasswordCardState extends State<ForgotPasswordCard> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          LoadingScreen().hide();
          showSnackBar(context, 'Failed to reset password', isError: true);
        } else if (state is AuthPasswordResetSent) {
          LoadingScreen().hide();
          showSnackBar(
            context,
            'Password Reset email has been sent',
            isError: false,
          );
        } else if (state is AuthLoggedOut) {
          LoadingScreen().hide();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        } else if(state is AuthLoading){
          LoadingScreen().show(context: context, text: 'Just a moment');
        }
      
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              // Email icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Email field
              Text(AppStrings.email, style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: AppStrings.enterEmail,
                  hintStyle: AppTextStyles.hintStyle,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borders),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Send reset email button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isEmpty || !email.contains('@')) {
                      showErrorDialog(context, 'Please enter a valid email');
                      return;
                    }
                    context.read<AuthBloc>().add(
                      AuthEventSendPasswordReset(email: email),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Send Reset Email',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Back to login button
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventIsUserLoggedIn());
                },
                child: Text(
                  'Back to Login',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
