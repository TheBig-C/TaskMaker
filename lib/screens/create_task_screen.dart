import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/config/config.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/providers/providers.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
import 'package:flutter_riverpod_todo_app/widgets/select_date_time_end.dart';
import 'package:flutter_riverpod_todo_app/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  static CreateTaskScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const CreateTaskScreen();
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _loading = false;
  String _status = 'Pendiente'; // Estado por defecto

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const DisplayWhiteText(
          text: 'Añade una nueva tarea',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                hintText: 'Nombre de la tarea',
                title: 'Nombre de la tarea',
                controller: _titleController,
              ),
              const Gap(30),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                items: <String>['Pendiente', 'En Progreso'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Status',
                ),
              ),
              const Gap(30),
              const CategoriesSelection(),
              const Gap(30),
              const SelectDateTime(),
              const Gap(30),
              Text(
                'Fecha y hora estimada para finalizacion: ',
              ),
              const Gap(30),
              const SelectDateTimeEnd(),
              const Gap(30),
              CommonTextField(
                hintText: 'Notas',
                title: 'Notas',
                maxLines: 6,
                controller: _noteController,
              ),
              const Gap(30),
              ElevatedButton(
                onPressed: _loading ? null : _createTask,
                child: _loading
                    ? Loader()
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Guardar',
                        ),
                      ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final title = _titleController.text.trim();
    final userId = currentUser!.uid;
    final note = _noteController.text.trim();
    final time = ref.watch(timeProvider);
    final date = ref.watch(dateProvider);
    final endTime = ref.watch(endTimeProvider);
    final endDate = ref.watch(endDateProvider);
    final category = ref.watch(categoryProvider);
    int isCompleted = 1; // Por defecto, en proceso

    if (_status == 'Pendiente') {
      isCompleted = 2; // Cambia a pendiente si es seleccionado
    }

    if (title.isNotEmpty) {
      final task = Task(
        title: title,
        userId: userId,
        category: category,
        time: Helpers.timeToString(time),
        date: DateFormat.yMMMd().format(date),
        endTime: Helpers.timeToString(endTime),
        endDate: DateFormat.yMMMd().format(endDate),
        note: note,
        isCompleted: isCompleted,
      );

      setState(() {
        _loading = true;
      });

      await ref.read(tasksProvider.notifier).createTask(task).then((value) {
        setState(() {
          _loading = false;
        });
        AppAlerts.displaySnackbar(context, 'Task create successfully');
        Navigator.of(context).pop();
      });
    } else {
      AppAlerts.displaySnackbar(context, 'Title cannot be empty');
    }
  }
}
