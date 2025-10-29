import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.hint,
    required this.iconAsset,
    required this.onTap,
    this.valueText,
    this.onClear,
  });

  final String hint;
  final String iconAsset;
  final String? valueText;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final hasValue = valueText != null && valueText!.isNotEmpty;

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
              SvgPicture.asset(
                iconAsset,
                height: 18,
                width: 18,
                colorFilter: const ColorFilter.mode(
                  Colors.black87,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasValue ? valueText! : hint,
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
