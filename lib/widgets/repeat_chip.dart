import 'package:flutter/material.dart';

class RepeatChip extends StatelessWidget {
  const RepeatChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.black : Colors.white;
    final fg = selected ? Colors.white : Colors.black;

    return Material(
      color: bg,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
