import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/common/error_page.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/user_profile/controller/user_profile_controller.dart';
import 'package:flutter_riverpod_todo_app/user_profile/widget/user_profile.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  
 
  const UserProfileView({
    Key? key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (QuerySnapshot<Map<String, dynamic>> data) {
              if (data.docs.isNotEmpty &&
                  data.docs.first.metadata.hasPendingWrites) {
                // Evento de actualización, actualizar el usuario
                if(userModel.uid==data.docs.first.id){
                copyOfUser = UserModel.fromMap(data.docs.first.data()!, documentId: data.docs.first.id);

                }
              }

              return UserProfile(user: copyOfUser);
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () {
              return UserProfile(user: copyOfUser);
            },
          ),
    );
  }
}
