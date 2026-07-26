import 'package:flutter/cupertino.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';

import '../../../core/utils/app_colors.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: context.easyColor(
          lColor: AppColors.primary,
          dColor: AppColors.backgroundLight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}
