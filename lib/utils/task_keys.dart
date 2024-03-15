import 'package:flutter/foundation.dart' show immutable;

@immutable
class TaskKeys {
  const TaskKeys._();
  static const String id = 'id';
  static const String title = 'title';
  static const String userId = 'userId';
  static const String category = 'category';
  static const String date = 'date';
  static const String time = 'time';
  static const String endDate = 'endDate';
  static const String endTime = 'endTime';
  static const String note = 'note';
  static const String isCompleted = 'isCompleted';
}
