import 'package:flutter/material.dart';

class PickerRow extends StatelessWidget {
  const PickerRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.onClear,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final hasValue = label != 'Set date' && label != 'Set time';
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: hasValue ? Colors.black : Colors.black54,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (hasValue && onClear != null)
                IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black54,
                  ),
                  onPressed: onClear,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
