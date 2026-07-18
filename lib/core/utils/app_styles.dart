import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  ///  ========================  inter font ===========================

  static TextStyle interRegular20White = GoogleFonts.inter(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static TextStyle interExtraLight14BackgroundLight = GoogleFonts.inter(
    color: AppColors.backgroundLight,
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  static TextStyle interMedium14BackgroundDark = GoogleFonts.inter(
    color: AppColors.backgroundDark,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle interMedium36White = GoogleFonts.inter(
    color: AppColors.white,
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );

  static TextStyle interSBold20Primary = GoogleFonts.inter(
    color: AppColors.primary,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static TextStyle interBold20yellow = GoogleFonts.inter(
    color: AppColors.primary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  /// ===========================  roboto font  ===========================

  static TextStyle robotoBold16SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold16Secondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.secondary,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoBold14SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoBold14gray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.gray,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular15White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16Primary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.primary,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular18White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular14White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular12White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular14Green(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.success,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular10White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular14SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoELight12SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark.withAlpha(179),
      fontSize: 12,
      fontWeight: FontWeight.w200,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular12Secondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.secondary,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular12Primary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.primary,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular14Secondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.secondary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular18Secondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.secondary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular18SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoBlack20SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 20,
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }


  static TextStyle robotoRegular12SurfaceDark(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.surfaceDark,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoRegular20Secondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.secondary,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  /// =================================================================
  static TextStyle robotoRegular14Primary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.primary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
  static TextStyle robotoBlack14Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.primary,
      fontSize: 14,
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16DarkGray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.primary,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular20White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold20White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold24White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold20LightGray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold30White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.white,
      fontSize: 30,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
}
