import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final String userId;
  final String note;
  final TaskCategory category;
  final String time;
  final String date;
  final bool isCompleted;
  const Task({
    this.id,
    required this.title,
    required this.userId,
    required this.category,
    required this.time,
    required this.date,
    required this.note,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TaskKeys.title: title,
      TaskKeys.userId: userId,
      TaskKeys.note: note,
      TaskKeys.category: category.name,
      TaskKeys.time: time,
      TaskKeys.date: date,
      TaskKeys.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Task.fromJson(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map[TaskKeys.title],
      userId: map[TaskKeys.userId] ?? '',
      note: map[TaskKeys.note],
      category: TaskCategory.stringToTaskCategory(map[TaskKeys.category]),
      time: map[TaskKeys.time],
      date: map[TaskKeys.date],
      isCompleted: map[TaskKeys.isCompleted] == 1 ? true : false,
    );
  }

  @override
  List<Object> get props {
    return [
      title,
      userId,
      note,
      category,
      time,
      date,
      isCompleted,
    ];
  }

  Task copyWith({
    String? id,
    String? title,
    String? userId,
    String? note,
    TaskCategory? category,
    String? time,
    String? date,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      category: category ?? this.category,
      time: time ?? this.time,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
