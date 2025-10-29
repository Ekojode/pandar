import 'package:flutter/material.dart';

import '../screens/home.dart';
import 'circle_check.dart';
import 'incomplete_content.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDone = task.completed;

    final titleStyle = TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w800,
      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
      color: isDone ? Colors.blueGrey : Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleCheck(completed: isDone, onTap: onToggle),
          const SizedBox(width: 12),
          Expanded(
            child: isDone
                ? Text(
                    task.title,
                    style: titleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : IncompleteContent(task: task, titleStyle: titleStyle),
          ),
        ],
      ),
    );
  }
}
