import 'package:finshyt/Features/auth/presentation/cards/login_card.dart';
import 'package:finshyt/Features/auth/presentation/cards/registration_card.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/constants/app_strings.dart';
import 'package:finshyt/core/constants/misc.dart';
import 'package:finshyt/Features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final AuthController _authController = AuthController();
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _authController.setAnimationController(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),

            _buildAnimatedCard(),

            const SizedBox(height: 16),

            _buildFooter(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.topPadding,),
          child: Center(
            child: Image.asset(
              Misc.logoUrl,
              height: 100, 
            ),
          ),
        ),
        Center(
          child: Text(
            AppStrings.tagline,
            style: GoogleFonts.inter(
              fontSize: 16, 
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ); 
  }

  Widget _buildAnimatedCard() {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final isShowingFront = _flipAnimation.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_flipAnimation.value * 3.14159),
          child: isShowingFront ? LoginCard() : RegistrationCard(),
        );
      },
    );
  }

  Widget _buildFooter() {
    return ListenableBuilder(
      listenable: _authController,
      builder: (context, child) {
        return Column(
          children: [
            Text(
              _authController.isLogin 
                  ? AppStrings.dontHaveAccount 
                  : AppStrings.alreadyHaveAccount,
              style: GoogleFonts.inter(
                color: AppColors.background,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: _authController.flipCard,
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: AppColors.secondaryButton,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _authController.isLogin ? AppStrings.register : AppStrings.login,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
