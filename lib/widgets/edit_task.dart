import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/data/data.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarea'),
      ),
      body: _loading ? Loader() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titulo'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(labelText: 'Nota'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _updateTask(context);
            },
            child: Text('Guardar cambios'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTask(BuildContext context) async {
    final tasksCollection = FirebaseFirestore.instance.collection('tasks');

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: widget.task.isCompleted,
      date: widget.task.date,
      time: widget.task.time,
      endDate: widget.task.endDate,
      endTime: widget.task.endTime,
      category: widget.task.category,
      userId: widget.task.userId,
    );

    setState(() {
      _loading = true;
    });

    await tasksCollection.doc(widget.task.id).update(updatedTask.toJson());

    setState(() {
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea actualizada correctamente!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
