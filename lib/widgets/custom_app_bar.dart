import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? centerTitle;

  const CustomAppBar({super.key, this.centerTitle});

  static const double _toolbarHeight = 110;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: _toolbarHeight,
      centerTitle: centerTitle ?? true,
      title: SvgPicture.asset(
        AppAssets.appLogo,
        alignment: Alignment.center,
        fit: .cover,
        height: 90,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_toolbarHeight);
}
