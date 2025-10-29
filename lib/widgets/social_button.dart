import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.asset,
    required this.onTap,
    required this.tooltip,
  });

  final String asset;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      customBorder: const CircleBorder(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.04),
        ),
        alignment: Alignment.center,
        child: Tooltip(
          message: tooltip,
          child: SvgPicture.asset(
            asset,
            height: 32,
            width: 32,
            //colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
