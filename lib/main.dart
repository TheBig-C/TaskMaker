import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/error_page.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/config/theme/app_theme.dart';
import 'package:flutter_riverpod_todo_app/screens/home_screen.dart';
import 'package:flutter_riverpod_todo_app/screens/home_view.dart';
import 'package:flutter_riverpod_todo_app/screens/welcomePage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //initializeAppAndDynamicLinks(initialLink, ref, context);

    return MaterialApp(
      title: 'TaskMaker',
      theme: AppTheme.light,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              } else {
                return const WelcomePage();
              }
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
