import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/constants/app_strings.dart';
import 'package:finshyt/constants/app_text_styles.dart';
import 'package:finshyt/screens/auth/forgot_password_view.dart';
import 'package:finshyt/screens/homeScreen/home_page.dart';
import 'package:finshyt/utility/loadingOverlay/loading_screen.dart';
import 'package:finshyt/widgets/common/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLogin = true;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  final border = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borders),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailure) {
          LoadingScreen().hide();
          showSnackBar(context, 'Authentication Failed');
        } else if (state is AuthPasswordResetInitiated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
            (route) => false,
          );
        } else if (state is AuthLoading) {
          LoadingScreen().show(context: context, text: 'Logging In');
        } else if (state is AuthSuccess) {
          LoadingScreen().hide();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), // Slightly smaller radius
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
                child: Text(AppStrings.login, style: AppTextStyles.cardTitle),
              ),
              const SizedBox(height: 32),

              // Username field
              Text(
                AppStrings.username,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                scrollPadding: const EdgeInsets.only(bottom: 100),
                decoration: InputDecoration(
                  hintText: AppStrings.enterUserName,
                  hintStyle: AppTextStyles.hintStyle,
                  border: border,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                  hintText: AppStrings.enterPassword,
                  hintStyle: AppTextStyles.hintStyle,
                  border: border,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(
                      const AuthEventNavigateToPasswordReset(),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _usernameController.text;
                    final password = _passwordController.text;
                    context.read<AuthBloc>().add(
                      AuthEventLogin(email: email, password: password),
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
                    AppStrings.login,
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
    );
  }
}
