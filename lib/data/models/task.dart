import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/utils/utils.dart';

class Task extends Equatable {
  final String? id;
  final String title;
  final String userId;
  final String note;
  final TaskCategory category;
  final String time;
  final String date;
  final String endTime;
  final String endDate;
  final int isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.userId,
    required this.note,
    required this.category,
    required this.time,
    required this.date,
    required this.endTime,
    required this.endDate,
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
      TaskKeys.endTime: endTime,
      TaskKeys.endDate: endDate,
      TaskKeys.isCompleted: isCompleted,
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
      endTime: map[TaskKeys.endTime]?? Helpers.timeToString( TimeOfDay.now()), // Agregado
      endDate: map[TaskKeys.endDate]?? Helpers.dateFormatter( DateTime.now()), // Agregado
      isCompleted: map[TaskKeys.isCompleted] ?? 6, // Usar 6 como valor predeterminado si es nulo
    );
  }

  @override
  List<Object?> get props {
    return [
      title,
      userId,
      note,
      category,
      time,
      date,
      endTime,
      endDate,
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
    String? endTime,
    String? endDate,
    int? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      category: category ?? this.category,
      time: time ?? this.time,
      date: date ?? this.date,
      endTime: endTime ?? this.endTime,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
