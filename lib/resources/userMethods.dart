import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/data/utils/failure.dart';
import 'package:flutter_riverpod_todo_app/data/utils/type_defs.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    firestore: FirebaseFirestore.instance,
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid);
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<QuerySnapshot<Map<String, dynamic>>> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final FirebaseFirestore _firestore;
  UserAPI({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.uid).set(
        userModel.toMap(),
      );
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

 @override
Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
  return _firestore.collection('users').doc(uid).get();
}

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchUserByName(String name) async {
    //final querySnapshot = await _firestore
       // .collection('users')
       /// .where('name', isEqualTo: name)
       // .get();
 final  querySnapshot = await _firestore.collection('users')
      //.where('name', isGreaterThanOrEqualTo: name)
      .where('name', isLessThan: name +'z' ) // Ajusta para obtener un rango más amplio
      .get();
    return querySnapshot.docs;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.uid).update(
        userModel.toMap(),
      );
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getLatestUserProfileData() {
    return _firestore.collection('users').snapshots();
  }
  
  @override
  FutureEitherVoid addToFollowing(UserModel user) {
    // TODO: implement addToFollowing
    throw UnimplementedError();
  }
  
  @override
  FutureEitherVoid followUser(UserModel user) {
    // TODO: implement followUser
    throw UnimplementedError();
  }
  }

