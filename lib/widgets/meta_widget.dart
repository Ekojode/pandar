import 'package:flutter/material.dart';

class Meta extends StatelessWidget {
  const Meta({
    super.key,
    required this.icon,
    required this.text,
    required this.style,
  });
  final IconData icon;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: style.color),
        if (text.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(text, style: style),
        ],
      ],
    );
  }
}
