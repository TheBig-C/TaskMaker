import 'package:firebase_auth/firebase_auth.dart' as model;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/apis/auth_api.dart';
import 'package:flutter_riverpod_todo_app/auth/view/login.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/data/utils/utils.dart';
import 'package:flutter_riverpod_todo_app/resources/userMethods.dart';
import 'package:flutter_riverpod_todo_app/screens/home_screen.dart';
import 'package:flutter_riverpod_todo_app/screens/home_view.dart';
import 'package:flutter_riverpod_todo_app/screens/welcomePage.dart';


final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.uid;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  ValueChanged<String?>? onMessage;
  ValueChanged<String?>? onEmailVerification;
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: name,
          profilePic: '',
          bannerPic: '',
          uid: r!.uid,
          bio: '',
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Accounted created! Please login.');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }

  
Future<UserModel> getUserData(String uid) async {
  final document = await _userAPI.getUserData(uid);
 
  if (document.exists) {
    final updatedUser = UserModel.fromMap(
        document.data() as Map<String, dynamic>,
        documentId: document.id, // Agrega el ID del documento al constructor
    );
    return updatedUser;
  } else {
    // Manejar el caso en que el documento no existe
    throw Exception('User data not found for uid: $uid');
  }
}
  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        WelcomePage.route(),
        (route) => false,
      );
    });
  }

  


}