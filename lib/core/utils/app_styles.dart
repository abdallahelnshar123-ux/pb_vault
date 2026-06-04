import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  ///  ========================  inter font ===========================
  static TextStyle interMedium36White = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 36,
    fontWeight: FontWeight.w500,
  );
  static TextStyle interRegular20White = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static TextStyle interRegular16White = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle interSBold20Black = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle interBold24white = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static TextStyle interSBold20yellow = GoogleFonts.inter(
    color: AppColors.yellowColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static TextStyle interBold20yellow = GoogleFonts.inter(
    color: AppColors.yellowColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  /// ===========================  roboto font  ===========================

  static TextStyle robotoRegular16White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular14Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.yellowColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular14Black(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular20DarkGray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.darkGrayColor,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular14White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular10White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBlack14Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.yellowColor,
      fontSize: 14,
      fontWeight: FontWeight.w900,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular15Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.yellowColor,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16DarkGray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.darkGrayColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular20Black(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular16Yellow(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.yellowColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoRegular20White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold20White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold24White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold20LightGray(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.lightGrayColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  static TextStyle robotoBold30White(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: AppColors.whiteColor,
      fontSize: 30,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }
}
