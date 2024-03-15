import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_todo_app/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod_todo_app/common/loading_page.dart';
import 'package:flutter_riverpod_todo_app/config/theme/pallete.dart';
import 'package:flutter_riverpod_todo_app/data/models/user.dart';
import 'package:flutter_riverpod_todo_app/user_profile/view/edit_profile_view.dart';
import 'package:flutter_riverpod_todo_app/user_profile/widget/stats.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: currentUser.bannerPic.isEmpty
                            ? Container(
                                color: Color.fromARGB(255, 118, 160, 183),
                              )
                            : Image.network(
                                currentUser.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == currentUser.uid) {
                              // edit profile
                              Navigator.push(context, EditProfileView.route());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: Text(
                            'Editar Perfil',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              currentUser.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '@${currentUser.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          currentUser.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 2),
                        const Divider(color: Pallete.whiteColor),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TaskStatisticsWidget(
              user: currentUser,
            ),
          );
  }
}