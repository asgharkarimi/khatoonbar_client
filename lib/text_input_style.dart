import 'package:flutter/material.dart';
import 'app_theme.dart';

class TextInputStyle {
  static InputDecoration getInputDecoration({
    required String labelText,
    IconData? prefixIcon,
    Widget? suffix,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: AppTheme.whiteColor,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppTheme.primaryColor)
          : null,
      suffix: suffix,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.dangerColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.dangerColor, width: 2),
      ),
      labelStyle: TextStyle(color: AppTheme.secondaryColor),
      hintStyle: TextStyle(color: AppTheme.secondaryColor.withOpacity(0.7)),
    );
  }

  static InputDecoration getDropdownDecoration({
    required String labelText,
    IconData? prefixIcon,
  }) {
    return getInputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
    ).copyWith(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }
}
