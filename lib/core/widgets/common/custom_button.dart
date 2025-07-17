import 'package:flutter/material.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color bgcolor;
  final Color textColor;
  final double? textSize;
  final double borderRadius;
  final IconData icon;
  final Color iconColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height, required this.bgcolor, required this.textColor,this.textSize, required this.borderRadius, required this.icon, required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,
          foregroundColor: AppColors.secondaryButton.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor,),
            SizedBox(width: 6,),
            Text(
              text,
              style: GoogleFonts.inter(color: textColor, fontSize: textSize, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }
}
