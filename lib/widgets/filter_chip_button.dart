import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 36,
  });

  final String label;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: Material(
        color: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/filter.svg',
                    height: 18,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.black87,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
