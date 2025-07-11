import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_strings.dart';
import 'package:finshyt/core/constants/app_text_styles.dart';
import 'package:finshyt/Features/homepage/homeScreen/home_page.dart';
import 'package:finshyt/core/utility/dialogs/showErrorDialog.dart';
import 'package:finshyt/core/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/core/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationCard extends StatefulWidget {
  const RegistrationCard({super.key});

  @override
  State<RegistrationCard> createState() => _RegistrationCardState();
}

class _RegistrationCardState extends State<RegistrationCard> {
  final border = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borders),
    borderRadius: BorderRadius.circular(20),
  );
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLogin = true;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailure) {
          LoadingScreen().hide();
          showSnackBar(context, 'Registration Failed', isError: true);
          // rregistration successful - show success message
        }
        if (state is AuthSuccess) {
          LoadingScreen().hide();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (state is AuthLoading) {
          LoadingScreen().show(context: context, text: 'Just a moment');
        }
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(3.14159),
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Text(
                    AppStrings.register,
                    style: AppTextStyles.cardTitle,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name field
                Text(AppStrings.fullName, style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _fullNameController,
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  decoration: InputDecoration(
                    hintText: AppStrings.enterFullName,
                    hintStyle: AppTextStyles.hintStyle,
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email field
                Text(
                  AppStrings.email,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppStrings.enterEmail,
                    hintStyle: AppTextStyles.hintStyle,
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                Text(AppStrings.password, style: AppTextStyles.fieldLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(
                        showPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off,
                        color: showPassword ? AppColors.icons : Colors.grey,
                      ),
                    ),
                    hintText: AppStrings.createPassword,
                    hintStyle: AppTextStyles.hintStyle,
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Verify Password field
                Text(
                  AppStrings.verifyPassword,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPasswordController,
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  obscureText: !showConfirmPassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                      child: Icon(
                        showConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off,
                        color: showConfirmPassword
                            ? AppColors.icons
                            : Colors.grey,
                      ),
                    ),
                    hintText: AppStrings.confirmPassword,
                    hintStyle: AppTextStyles.hintStyle,
                    border: border,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final fullName = _fullNameController.text.trim();
                      final email = _usernameController.text.trim();
                      final password = _passwordController.text;
                      final confirmPassword = _confirmPasswordController.text;

                      if (fullName.isEmpty) {
                        showErrorDialog(context, 'Please enter your full name');
                        return;
                      }

                      if (email.isEmpty || !email.contains('@')) {
                        showErrorDialog(context, 'Please enter a valid email');
                        return;
                      }

                      if (password.length < 6) {
                        showErrorDialog(
                          context,
                          'Password must be at least 6 characters',
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        showErrorDialog(context, 'Passwords do not match');
                        return;
                      }

                      context.read<AuthBloc>().add(
                        AuthEventSignUp(
                          name: _fullNameController.text.trim(),
                          email: email.trim(),
                          password: password.trim(),
                        ),
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
                      AppStrings.register,
                      style: GoogleFonts.inter(
                        color: AppColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
