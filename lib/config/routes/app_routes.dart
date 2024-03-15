import 'package:flutter_riverpod_todo_app/config/config.dart';
import 'package:flutter_riverpod_todo_app/screens/screens.dart';
import 'package:flutter_riverpod_todo_app/screens/welcomePage.dart';
import 'package:go_router/go_router.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.home,
    parentNavigatorKey: navigationKey,
    builder: WelcomePage.builder,
  ),
  GoRoute(
    path: RouteLocation.createTask,
    parentNavigatorKey: navigationKey,
    builder: CreateTaskScreen.builder,
  ),
];
