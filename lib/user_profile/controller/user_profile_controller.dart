import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/apis/storage_api.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/data/utils/utils.dart';
import 'package:flutter_riverpod_todo_app/resources/userMethods.dart';


final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileController({
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  })  : 
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);



  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

}
