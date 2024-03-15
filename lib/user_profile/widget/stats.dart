import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/data/models/task.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/utils/task_category.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TaskStatisticsWidget extends StatelessWidget {
  final UserModel user;
  TaskStatisticsWidget({
    super.key,
    required this.user,
  });
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      return FutureBuilder<List<Task>>(
        future: _fetchFilteredTasks(tasksCollection, user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Task> tasks = snapshot.data ?? [];

            Map<TaskCategory, int> categoryCounts =
                calculateMostUsedCategories(tasks);
            Map<String, int> completionStatus =
                calculateCompletionStatus(tasks);
            double averageTimePerTask = calculateAverageTimePerTask(tasks);
            Map<String, int> taskDistribution =
                calculateTaskDistributionByDate(tasks);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Estadisticas del usuario: ',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(16),
                    child: mostUsedCategoriesChart(categoryCounts),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(16),
                    child: completionStatusChart(completionStatus),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Tiempo promedio por tarea: $averageTimePerTask',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(16),
                    child: taskDistributionChart(taskDistribution),
                  ),
                ],
              ),
            );
          }
        },
      );
    });
  }

  Future<List<Task>> _fetchFilteredTasks(
      CollectionReference collection, String userId) async {
    final querySnapshot =
        await collection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) => Task.fromJson(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Map<TaskCategory, int> calculateMostUsedCategories(List<Task> tasks) {
    Map<TaskCategory, int> categoryCounts = {};
    tasks.forEach((task) {
      if (categoryCounts.containsKey(task.category)) {
        categoryCounts[task.category] = categoryCounts[task.category]! + 1;
      } else {
        categoryCounts[task.category] = 1;
      }
    });
    return categoryCounts;
  }

  Map<String, int> calculateCompletionStatus(List<Task> tasks) {
    int completed = 0;
    int inProgress = 0;
    int pending = 0;
    tasks.forEach((task) {
      if (task.isCompleted == 0) {
        completed++;
      } else if (task.isCompleted == 1) {
        inProgress++;
      } else if (task.isCompleted == 2) {
        pending++;
      }
    });
    return {
      'Completed': completed,
      'In Progress': inProgress,
      'Pending': pending,
    };
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }
    // Si el formato no es válido, devolvemos la hora predeterminada
    return TimeOfDay.now();
  }

  double calculateAverageTimePerTask(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;

    double totalTime = 0.0;
    tasks.forEach((task) {
      final startTime = _parseTime(task.time);
      final endTime = _parseTime(task.endTime);

      final taskDuration = endTime.hour * 60 +
          endTime.minute -
          (startTime.hour * 60 + startTime.minute);

      totalTime += taskDuration.toDouble() + 30;
    });

    return totalTime / tasks.length;
  }

  Map<String, int> calculateTaskDistributionByDate(List<Task> tasks) {
    Map<String, int> distribution = {};
    tasks.forEach((task) {
      final taskDate = task.date;

      distribution.update(
        taskDate,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    });
    return distribution;
  }

  Widget mostUsedCategoriesChart(Map<TaskCategory, int> categoryCounts) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries<TaskCategory, String>>[
        ColumnSeries<TaskCategory, String>(
          dataSource: categoryCounts.entries.map((entry) => entry.key).toList(),
          xValueMapper: (TaskCategory category, _) =>
              category.toString().substring(13),
          yValueMapper: (TaskCategory category, _) => categoryCounts[category],
          dataLabelSettings: DataLabelSettings(
              isVisible: true), // Mostrar valores encima de las barras
        ),
      ],
      legend: Legend(isVisible: true), // Agregar leyenda al gráfico
    );
  }

  Widget completionStatusChart(Map<String, int> completionStatus) {
    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<MapEntry<String, int>, String>(
          dataSource: completionStatus.entries.toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: DataLabelSettings(
              isVisible: true), // Mostrar valores dentro del pastel
        ),
      ],
      legend: Legend(isVisible: true), // Agregar leyenda al gráfico
    );
  }

  Widget taskDistributionChart(Map<String, int> distribution) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<MapEntry<String, int>, String>(
          dataSource: distribution.entries.toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: DataLabelSettings(
              isVisible: true), // Mostrar valores encima de las barras
        ),
      ],
      legend: Legend(isVisible: true), // Agregar leyenda al gráfico
    );
  }
}
