
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(

      content: Text(
        message,
        style: TextStyle(

          color: isError ? colorScheme.onError : colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      backgroundColor: isError ? colorScheme.error : colorScheme.secondary,

      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      margin: const EdgeInsets.all(10),
    ),
  );
}
