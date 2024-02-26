import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? size;
  const SvgIcon({Key? key, required this.icon, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      color: color,
      width: size ?? 24,
      height: size ?? 24,
    );
  }
}
