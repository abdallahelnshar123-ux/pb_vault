import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const double _toolbarHeight = 110;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      title: SvgPicture.asset(AppAssets.appLogo, alignment: Alignment.center),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}
