// lib/utility/loadingOverlay/loading_screen.dart
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen {
  static final LoadingScreen _instance = LoadingScreen._internal();
  factory LoadingScreen() => _instance;
  LoadingScreen._internal();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void show({required BuildContext context, required String text}) {
    if (_isShowing) {
      return;
    }

    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlay(text));

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  void hide() {
    if (!_isShowing || _overlayEntry == null) {
      return;
    }

    _overlayEntry!.remove();

    _overlayEntry = null;
    _isShowing = false;
  }

  Widget _buildOverlay(String text) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.secondaryButton),
              const SizedBox(height: 16),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppColors.text, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
