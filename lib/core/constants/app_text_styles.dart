import 'package:finshyt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get cardTitle =>
      GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle get fieldLabel =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get hintStyle =>
      GoogleFonts.inter(color: AppColors.primary.withOpacity(0.6));
      
  static TextStyle get buttonText =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);
}
