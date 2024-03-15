import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/data/models/task.dart';
import 'package:flutter_riverpod_todo_app/widgets/task_details.dart';

class SearchScreen extends StatefulWidget {
  final String? currentUser;

  const SearchScreen(this.currentUser);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<Task> _filteredTasks = [];
  TaskStatus _selectedStatus = TaskStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Tareas'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton('Todas', TaskStatus.all),
              _buildFilterButton('Completadas', TaskStatus.completed),
              _buildFilterButton('En Progreso', TaskStatus.inProgress),
              _buildFilterButton('Incompletas', TaskStatus.incomplete),
            ],
          ),
          const SizedBox(height: 20),
          // Mostrar las tareas filtradas
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => TaskDetails(task: task),
                    );
                  },
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.date),
                        if (task.note != null) Text(task.note!),
                      ],
                    ),
                    trailing: _buildCompletionStatusIcon(task.isCompleted),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildFilterButton(String label, TaskStatus status) {
    final isSelected = _selectedStatus == status;
    final primaryColor =
        isSelected ? Color.fromARGB(255, 118, 160, 183) : Colors.white;
    final borderColor =
        isSelected ? Color.fromARGB(255, 118, 160, 183) : Colors.grey[300]!;
    final textColor =
        isSelected ? Colors.white : Color.fromARGB(255, 118, 160, 183);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedStatus = status;
          _updateSearchQuery(_searchQuery);
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: borderColor),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterTasks(query, widget.currentUser, _selectedStatus);
  }

  void _filterTasks(
      String query, String? currentUser, TaskStatus selectedStatus) {
    final tasksCollection = FirebaseFirestore.instance.collection('tasks');
    Query taskQuery = tasksCollection
        .where('userId',
            isEqualTo: currentUser) // Filtra por el ID del usuario en sesión
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z');

    // Aplicar el filtro según el estado seleccionado
    switch (selectedStatus) {
      case TaskStatus.completed:
        taskQuery = taskQuery.where('isCompleted', isEqualTo: 0);
        break;
      case TaskStatus.inProgress:
        taskQuery = taskQuery.where('isCompleted', isEqualTo: 1);
        break;
      case TaskStatus.incomplete:
        taskQuery = taskQuery.where('isCompleted', isEqualTo: 2);
        break;
      default:
        // No se aplica ningún filtro adicional si se selecciona "Todas"
        break;
    }

    taskQuery.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        _filteredTasks = querySnapshot.docs
            .map((doc) =>
                Task.fromJson(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    }).catchError((error) {
      print('Error filtering tasks: $error');
      // Manejar el error si la búsqueda falla
    });
  }

  Widget _buildCompletionStatusIcon(int isCompleted) {
    IconData icon;
    Color color;
    String text;
    switch (isCompleted) {
      case 0:
        icon = Icons.check_circle;
        color = Colors.green;
        text = 'Completada';
        break;
      case 1:
        icon = Icons.pending_actions;
        color = Colors.orange;
        text = 'En progreso';
        break;
      case 2:
        icon = Icons.error;
        color = Colors.red;
        text = 'Incompleta';
        break;
      default:
        icon = Icons.error;
        color = Colors.red;
        text = 'Desconocido';
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}

enum TaskStatus {
  all,
  completed,
  inProgress,
  incomplete,
}
