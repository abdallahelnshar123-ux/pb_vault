import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final String platformId;

  final double size;

  const PlatformIcon({
    super.key,
    required this.platformId,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final icon = platformIcons[platformId];

    if (icon != null) {
      return Icon(
        icon,
        size: size,
      );
    }

    final asset = customIcons[platformId];

    if (asset != null) {
      return SvgPicture.asset(
        asset,
        width: size,
        height: size,
      );
    }

    return Icon(
      Icons.public,
      size: size,
    );
  }
}