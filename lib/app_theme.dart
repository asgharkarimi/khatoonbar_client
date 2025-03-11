import 'package:flutter/material.dart';
import 'text_input_style.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007BFF);
  static const Color secondaryColor = Color(0xFF6C757D);
  static const Color successColor = Color(0xFF28A745);
  static const Color dangerColor = Color(0xFFDC3545);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF17A2B8);
  static const Color lightColor = Color(0xFFF8F9FA);
  static const Color darkColor = Color(0xFF343A40);

  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;

  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.green,

      // Persian font
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff2E7D32),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff2E7D32),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: whiteColor,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dangerColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dangerColor, width: 2),
        ),
        labelStyle: TextStyle(color: secondaryColor),
        hintStyle: TextStyle(color: secondaryColor.withOpacity(0.7)),
        prefixIconColor: primaryColor,
        suffixIconColor: secondaryColor,
      ),
    );
  }

  static InputDecoration getInputDecoration({
    required String labelText,
    IconData? prefixIcon,
    Widget? suffix,
    String? hintText,
  }) {
    return TextInputStyle.getInputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffix: suffix,
      hintText: hintText,
    );
  }
}
