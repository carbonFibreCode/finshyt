
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finshyt/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.controller,this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      scrollPadding: const EdgeInsets.only(bottom: 100),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: AppColors.primary.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borders),
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
