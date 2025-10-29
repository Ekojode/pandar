import 'package:flutter/material.dart';

import '../screens/home.dart';
import 'meta_widget.dart';

class IncompleteContent extends StatelessWidget {
  const IncompleteContent({
    super.key,
    required this.task,
    required this.titleStyle,
  });

  final Task task;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final metaStyle = TextStyle(
      fontSize: 12,
      height: 1.33,
      color: Colors.blueGrey.shade600,
      fontWeight: FontWeight.w600,
    );

    final List<Widget> meta = [];
    if (task.time != null) {
      meta.add(
        Meta(icon: Icons.access_time, text: task.time!, style: metaStyle),
      );
    }
    if (task.date != null) {
      meta.add(Meta(icon: Icons.event, text: task.date!, style: metaStyle));
    }
    if (task.hasNotification) {
      meta.add(Meta(icon: Icons.notifications, text: '', style: metaStyle));
    }
    if ((task.repeatRule ?? '').isNotEmpty) {
      meta.add(
        Meta(icon: Icons.repeat, text: task.repeatRule!, style: metaStyle),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if ((task.description ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2.0, right: 8),
            child: Text(
              task.description!,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.blueGrey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (meta.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(spacing: 12, runSpacing: 6, children: meta),
          ),
      ],
    );
  }
}
