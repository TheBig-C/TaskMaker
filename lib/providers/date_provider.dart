import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
final endDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
