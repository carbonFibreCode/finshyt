
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLogin = true;

  bool get showPassword => _showPassword;
  bool get showConfirmPassword => _showConfirmPassword;
  bool get isLogin => _isLogin;

  AnimationController? _animationController;

  void setAnimationController(AnimationController controller) {
    _animationController = controller;
  }

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _showConfirmPassword = !_showConfirmPassword;
    notifyListeners();
  }

  void flipCard() {
    if (_animationController != null) {
      if (_isLogin) {
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
      _isLogin = !_isLogin;
      notifyListeners();
    }
  }
}
