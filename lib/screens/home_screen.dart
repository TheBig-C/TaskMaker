import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/providers/date_provider.dart';
import 'package:flutter_riverpod_todo_app/screens/create_task_screen.dart';
import 'package:flutter_riverpod_todo_app/screens/search_screen.dart';
import 'package:flutter_riverpod_todo_app/widgets/side_drawer.dart';
import 'package:flutter_riverpod_todo_app/widgets/widgets.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final date = ref.watch(dateProvider);
    final CollectionReference tasksCollection =
        FirebaseFirestore.instance.collection('tasks');

    return Scaffold(
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 130,
              child: Stack(
                children: [
                  AppBackground(
                    headerHeight: 130,
                    header: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => Helpers.selectDate(context, ref),
                          child: DisplayWhiteText(
                            text: Helpers.dateFormatter(date),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const DisplayWhiteText(text: 'Mis Tareas', size: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchScreen(currentUser?.uid), // Crear una instancia de la página de búsqueda
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: DisplayWhiteText(
                  text: 'Search Tasks',
                ),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: tasksCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                final List<Task> tasks =
                    snapshot.data!.docs.map((QueryDocumentSnapshot document) {
                  final Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Task.fromJson(document.id, data);
                }).toList();
                final List<Task> inProgressTasks =
                    tasks.where((task) => task.isCompleted == 2).toList();
                final List<Task> inCompletedTasks =
                    tasks.where((task) => task.isCompleted == 1).toList();
                final List<Task> completedTasks =
                    tasks.where((task) => task.isCompleted == 0).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(currentUser
                                ?.uid), // Crear una instancia de la página de búsqueda
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Buscar Tareas',
                        ),
                      ),
                    ),
                    Text(
                      'In pending',
                      style: context.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      tasks: inProgressTasks,
                    ),
                    Text(
                      'In progress',
                      style: context.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      tasks: inCompletedTasks,
                    ),
                    Text(
                      'Completed',
                      style: context.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      isCompletedTasks: true,
                      tasks: completedTasks,
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Add New Task',
                        ),
                      ),
                    ),
                    const Gap(20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
