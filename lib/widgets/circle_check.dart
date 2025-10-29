import 'package:flutter/material.dart';

class CircleCheck extends StatelessWidget {
  const CircleCheck({super.key, required this.completed, required this.onTap});
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      customBorder: const CircleBorder(),
      radius: 24,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: completed ? Colors.blue : Colors.blueGrey.shade200,
            width: 2,
          ),
          color: completed ? Colors.blue : Colors.transparent,
        ),
        child: completed
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
