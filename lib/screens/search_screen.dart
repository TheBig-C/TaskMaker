import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/data/models/task.dart';
import 'package:path/path.dart';

class SearchScreen extends StatefulWidget {
  final String? currentUser;

  const SearchScreen(this.currentUser);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<Task> _filteredTasks = [];

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    print(widget.currentUser);
    _filterTasks(query, widget.currentUser);
  }

  void _filterTasks(String query, String? currentUser) {
    final tasksCollection = FirebaseFirestore.instance.collection('tasks');
    tasksCollection
    
        //.where('userId', isEqualTo: currentUser)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Tasks'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: _updateSearchQuery,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 20),
          // Mostrar las tareas filtradas
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.date),
                  // Aquí puedes agregar más información de la tarea si lo deseas
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
