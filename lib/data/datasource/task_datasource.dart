import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';

class TaskDatasource {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toJson());
  }

 Future<List<Task>> getAllTasks() async {
  final QuerySnapshot querySnapshot = await _tasksCollection.get();
  return querySnapshot.docs.map((doc) => Task.fromJson(doc.id, doc.data() as Map<String, dynamic>)).toList();
}
  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id.toString()).set(task.toJson());
  }

  Future<void> deleteTask(Task task) async {
    await _tasksCollection.doc(task.id.toString()).delete();
  }
}
