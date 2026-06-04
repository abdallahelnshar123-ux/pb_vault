import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

class MainLoadingWidget extends StatelessWidget {
  const MainLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 1.2,
        color: AppColors.yellowColor,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
