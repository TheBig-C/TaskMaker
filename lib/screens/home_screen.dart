import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< Updated upstream
import 'package:flutter_riverpod_todo_app/config/config.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/providers/providers.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
=======
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';
import 'package:flutter_riverpod_todo_app/providers/date_provider.dart';
import 'package:flutter_riverpod_todo_app/screens/create_task_screen.dart';
import 'package:flutter_riverpod_todo_app/screens/search_screen.dart';
import 'package:flutter_riverpod_todo_app/user_profile/widget/user_profile.dart'; // Import UserProfile widget
import 'package:flutter_riverpod_todo_app/utils/utils.dart';
import 'package:flutter_riverpod_todo_app/widgets/side_drawer.dart';
>>>>>>> Stashed changes
import 'package:flutter_riverpod_todo_app/widgets/widgets.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HomeScreen();
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final date = ref.watch(dateProvider);
    final taskState = ref.watch(tasksProvider);
    final inCompletedTasks = _incompltedTask(taskState.tasks, ref);
    final completedTasks = _compltedTask(taskState.tasks, ref);

    TextStyle robotoStyle = TextStyle(fontFamily: 'Roboto');

    return Scaffold(
<<<<<<< Updated upstream
      body: Stack(
        children: [
          AppBackground(
            headerHeight: deviceSize.height * 0.3,
            header: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Helpers.selectDate(context, ref),
                    child: DisplayWhiteText(
                      text: Helpers.dateFormatter(date),
                      fontWeight: FontWeight.normal,
=======
      backgroundColor: Color.fromARGB(255, 180, 197, 224),
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
                          child: Text(
                            Helpers.dateFormatter(date),
                            style: robotoStyle.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const Text(
                          'Mis Tareas',
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
>>>>>>> Stashed changes
                    ),
                  ),
                  const DisplayWhiteText(text: 'My Todo List', size: 40),
                ],
              ),
            ),
<<<<<<< Updated upstream
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
=======
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: tasksCollection
                  .where('userId', isEqualTo: currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: robotoStyle,
                  );
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
                    Text(
                      'Pendientes',
                      style: robotoStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      tasks: inProgressTasks,
                    ),
                    Text(
                      'En Progreso',
                      style: robotoStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
>>>>>>> Stashed changes
                    DisplayListOfTasks(
                      tasks: inCompletedTasks,
                    ),
                    const Gap(20),
                    Text(
<<<<<<< Updated upstream
                      'Completed',
                      style: context.textTheme.headlineSmall?.copyWith(
=======
                      'Completadas',
                      style: robotoStyle.copyWith(
>>>>>>> Stashed changes
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(20),
                    DisplayListOfTasks(
                      isCompletedTasks: true,
                      tasks: completedTasks,
                    ),
                    const Gap(20),
<<<<<<< Updated upstream
                    ElevatedButton(
                      onPressed: () => context.push(RouteLocation.createTask),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DisplayWhiteText(
                          text: 'Add New Task',
                        ),
                      ),
                    ),
=======
>>>>>>> Stashed changes
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        currentUser?.uid), // Navigate to search screen
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                if (currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(user: currentUser!),
                    ),
                  );
                } else {
                  // Handle the case where currentUser is null
                }
              },
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }

  List<Task> _incompltedTask(List<Task> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Task> filteredTask = [];

    for (var task in tasks) {
      if (!task.isCompleted) {
        final isTaskDay = Helpers.isTaskFromSelectedDate(task, date);
        if (isTaskDay) {
          filteredTask.add(task);
        }
      }
    }
    return filteredTask;
  }

  List<Task> _compltedTask(List<Task> tasks, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final List<Task> filteredTask = [];

    for (var task in tasks) {
      if (task.isCompleted) {
        final isTaskDay = Helpers.isTaskFromSelectedDate(task, date);
        if (isTaskDay) {
          filteredTask.add(task);
        }
      }
    }
    return filteredTask;
  }
}
