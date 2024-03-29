import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/providers/providers.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'common_text_field.dart';

class SelectDateTimeEnd extends ConsumerWidget {
  const SelectDateTimeEnd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(endTimeProvider);
    final date = ref.watch(endDateProvider);

    return Row(
      children: [
        Expanded(
          child: CommonTextField(
            title: 'Fecha',
            hintText: Helpers.dateFormatter(date),
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: () => Helpers.selectDateEnd(context, ref),
              icon: const FaIcon(FontAwesomeIcons.calendar),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: CommonTextField(
            title: 'Hora',
            hintText: Helpers.timeToString(time),
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: () => _selectTime(context, ref),
              icon: const FaIcon(FontAwesomeIcons.clock),
            ),
          ),
        ),
      ],
    );
  }

  void _selectTime(BuildContext context, WidgetRef ref) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      ref.read(endTimeProvider.notifier).state = pickedTime;
    }
  }
}
