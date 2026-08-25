import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/constants/platforms.dart';

class PlatformIcon extends StatelessWidget {
  final String platformId;

  final double size;

  const PlatformIcon({super.key, required this.platformId, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final platform = appPlatforms[platformId];

    if (platform == null) {
      return Icon(Icons.public, size: size);
    }

    if (platform.icon != null) {
      return Icon(platform.icon, size: size, color: platform.color);
    }

    if (platform.iconPath != null) {
      return SvgPicture.asset(
        platform.iconPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    return Icon(Icons.public, size: size);
  }
}
