import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import '../core/utils/screen_size.dart';

class MainErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressed;
  final double widgetHeight;

  const MainErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onPressed,
    required this.widgetHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widgetHeight,
      width: double.infinity,
      padding: EdgeInsets.only(top: context.height * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: context.height * 0.03,
        children: [
          Text(
            errorMessage,
            style: AppStyles.robotoBold20White(context),
            textAlign: TextAlign.center,
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              backgroundColor: AppColors.primary,
            ),
            onPressed: onPressed,
            child: Text(
              'try again',
              style: AppStyles.robotoRegular20Black(context),
            ),
          ),
        ],
      ),
    );
  }
}
