import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/data/utils/failure.dart';
import 'package:flutter_riverpod_todo_app/data/utils/type_defs.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI();
});

abstract class IAuthAPI {
  FutureEither<User?> signUp({
    required String email,
    required String password,
  });
  FutureEither<UserCredential> login({
    required String email,
    required String password,
  });
  Future<User?> currentUserAccount();
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> currentUserAccount() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(_firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _firebaseAuth.signOut();
      return right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  // Firebase doesn't require a separate method for Google Sign-In. You can use Firebase's built-in Google Sign-In functionality.
  // Make sure to configure OAuth in the Firebase Console for Google Sign-In to work.

  // Future<void> googleSignIn() async {
  //   try {
  //     // Perform Google Sign-In using Firebase
  //     // ...
  //     await Future.delayed(const Duration(microseconds: 500));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
