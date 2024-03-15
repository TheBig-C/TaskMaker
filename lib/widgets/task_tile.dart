import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
import 'package:flutter_riverpod_todo_app/widgets/widgets.dart';
import 'package:gap/gap.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.onCompleted,
  });

  final Task task;

  final Function(bool?)? onCompleted;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

<<<<<<< Updated upstream
    final textDecoration =
        task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none;
    final fontWeight = task.isCompleted ? FontWeight.normal : FontWeight.bold;
    final double iconOpacity = task.isCompleted ? 0.3 : 0.5;
    final double backgroundOpacity = task.isCompleted ? 0.1 : 0.3;
=======
    final textDecoration = task.isCompleted == 0
        ? TextDecoration.lineThrough
        : TextDecoration.none;
    final fontWeight =
        task.isCompleted == 0 ? FontWeight.normal : FontWeight.bold;
    final double iconOpacity = task.isCompleted == 0 ? 0.3 : 0.5;
    final double backgroundOpacity = task.isCompleted == 0 ? 0.1 : 0.3;
>>>>>>> Stashed changes

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          CircleContainer(
            borderColor: task.category.color,
            color: task.category.color.withOpacity(backgroundOpacity),
            child: Icon(
              task.category.icon,
              color: task.category.color.withOpacity(iconOpacity),
            ),
          ),
          const Gap(16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: style.titleMedium?.copyWith(
                  fontWeight: fontWeight,
                  fontSize: 20,
                  decoration: textDecoration,
                ),
              ),
              Text(
                task.time,
                style: style.titleMedium?.copyWith(
                  decoration: textDecoration,
                ),
              ),
            ],
          )),
          Checkbox(
<<<<<<< Updated upstream
            value: task.isCompleted,
=======
            value: task.isCompleted == 0,
>>>>>>> Stashed changes
            onChanged: onCompleted,
            checkColor: colors.surface,
            // fillColor: MaterialStateProperty.resolveWith<Color>(
            //   (Set<MaterialState> states) {
            //     if (states.contains(MaterialState.disabled)) {
            //       return colors.primary;
            //     }
            //     return colors.primary;
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
