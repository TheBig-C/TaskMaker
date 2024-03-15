import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/config/config.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/providers/providers.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
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
<<<<<<< Updated upstream
=======
  bool _loading = false;
  String _status = 'Pendiente'; // Estado por defecto
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
=======
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
>>>>>>> Stashed changes
              const CategoriesSelection(),
              const Gap(30),
              const SelectDateTime(),
              const Gap(30),
<<<<<<< Updated upstream
=======
              Text(
                'Fecha y hora estimada para finalizacion: ',
              ),
              const Gap(30),
              const SelectDateTimeEnd(),
              const Gap(30),
>>>>>>> Stashed changes
              CommonTextField(
                hintText: 'Notas',
                title: 'Notas',
                maxLines: 6,
                controller: _noteController,
              ),
              const Gap(30),
              ElevatedButton(
<<<<<<< Updated upstream
                onPressed: _createTask,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DisplayWhiteText(
                    text: 'Save',
                  ),
                ),
=======
                onPressed: _loading ? null : _createTask,
                child: _loading
                    ? Loader()
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Guardar',
                        ),
                      ),
>>>>>>> Stashed changes
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final time = ref.watch(timeProvider);
    final date = ref.watch(dateProvider);
    final category = ref.watch(categoryProvider);
<<<<<<< Updated upstream
=======
    int isCompleted = 1; // Por defecto, en proceso

    if (_status == 'Pendiente') {
      isCompleted = 2; // Cambia a pendiente si es seleccionado
    }

>>>>>>> Stashed changes
    if (title.isNotEmpty) {
      final task = Task(
        title: title,
        category: category,
        time: Helpers.timeToString(time),
        date: DateFormat.yMMMd().format(date),
        note: note,
        isCompleted: false,
      );

      await ref.read(tasksProvider.notifier).createTask(task).then((value) {
<<<<<<< Updated upstream
        AppAlerts.displaySnackbar(context, 'Task create successfully');
        context.go(RouteLocation.home);
=======
        setState(() {
          _loading = false;
        });
        AppAlerts.displaySnackbar(context, 'Tarea creada exitosamente!');
        Navigator.of(context).pop();
>>>>>>> Stashed changes
      });
    } else {
      AppAlerts.displaySnackbar(context, 'El titulo no puede estar vacio');
    }
  }
}
