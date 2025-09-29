import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimen.dart';

class AppTheme {
  static final dark = ThemeData.dark().copyWith(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      iconTheme: const IconThemeData(color: AppColors.terneryColor),
      cardColor: AppColors.cardColor,
      hintColor: AppColors.hintColor,
      dividerColor: AppColors.dividerColor,
      textTheme: TextTheme(
        displayLarge: getTextStyle(
            color: AppColors.primaryColor,
            FontDimen.dimen24,
            fontWeight: FontWeight.w700),
        displayMedium: getTextStyle(
            color: AppColors.secondaryColor,
            FontDimen.dimen18,
            fontWeight: FontWeight.w700),
        displaySmall: getTextStyle(
            color: AppColors.terneryColor,
            FontDimen.dimen20,
            fontWeight: FontWeight.w700),
        headlineLarge: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen18,
        ),
        headlineMedium: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen18,
        ),
        headlineSmall: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleLarge: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleMedium: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleSmall: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen14,
        ),
        labelLarge: getTextStyle(
          color: AppColors.hintColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        labelMedium: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen14,
        ),
        labelSmall: getTextStyle(
            color: AppColors.primaryColor,
            FontDimen.dimen16,
            fontWeight: FontWeight.w700),
        bodyLarge: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen12,
        ),
        bodyMedium: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen10,
        ),
        bodySmall: getTextStyle(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen12,
        ),
      ));

  static final light = ThemeData.light().copyWith(
      primaryColor: AppColors.secondaryColor,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: AppColors.terneryColor),
      cardColor: AppColors.terneryColor.withOpacity(0.1),
      hintColor: AppColors.hintColor,
      dividerColor: AppColors.dividerColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: GoogleFonts.bigshotOne(
          fontSize: FontDimen.dimen24,
          fontWeight: FontWeight.w600,
          color: AppColors.secondaryColor.withOpacity(
            0.8,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: getTextStyle(
            color: AppColors.secondaryColor,
            FontDimen.dimen18,
            fontWeight: FontWeight.w700),
        displayMedium: getTextStyle(
            color: AppColors.primaryColor,
            FontDimen.dimen18,
            fontWeight: FontWeight.w700),
        displaySmall: getTextStyle(
            color: AppColors.terneryColor,
            FontDimen.dimen20,
            fontWeight: FontWeight.w700),
        headlineLarge: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen18,
        ),
        headlineMedium: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen18,
        ),
        headlineSmall: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleLarge: getTextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleMedium: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        titleSmall: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen14,
        ),
        labelLarge: getTextStyle(
          color: AppColors.hintColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen16,
        ),
        labelMedium: getTextStyle(
          color: AppColors.terneryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen14,
        ),
        labelSmall: getTextStyle(
            color: AppColors.secondaryColor,
            FontDimen.dimen16,
            fontWeight: FontWeight.w700),
        bodyLarge: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen12,
        ),
        bodyMedium: getTextStyle(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen10,
        ),
        bodySmall: getTextStyle(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w400,
          FontDimen.dimen12,
        ),
      ));
}

TextStyle getTextStyle(
  double size, {
  FontWeight? fontWeight,
  String? fontFamily,
  Color? color,
}) =>
    GoogleFonts.inter(
      textStyle: TextStyle(
          color: color ?? AppColors.secondaryColor,
          fontSize: size,
          fontWeight: fontWeight ?? FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.30),
    );
