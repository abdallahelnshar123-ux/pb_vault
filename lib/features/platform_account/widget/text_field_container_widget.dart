import 'package:flutter/material.dart';
import 'package:pb_vault/core/utils/app_colors.dart';

class TextFieldContainerWidget extends StatelessWidget {
  const TextFieldContainerWidget({
    super.key,
    required this.child,
    required this.text,
    required this.style,
  });

  final Widget child;

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsetsDirectional.only(top: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: style),
          ),
          child,
        ],
      ),
    );
  }
}
