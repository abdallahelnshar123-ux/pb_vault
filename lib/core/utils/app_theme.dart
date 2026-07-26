import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    popupMenuTheme: PopupMenuThemeData(color: AppColors.backgroundDark),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.backgroundDark),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.secondary),
      titleTextStyle: TextStyle(
        color: AppColors.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
  static ThemeData lightTheme = ThemeData(
    popupMenuTheme: PopupMenuThemeData(color: AppColors.backgroundDark),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.backgroundLight),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.surfaceDark),
      titleTextStyle: TextStyle(
        color: AppColors.surfaceDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  );
}
