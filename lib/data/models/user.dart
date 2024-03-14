import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
@immutable
class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;

  const UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,

  });

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
    );
  }
 // Método para crear un objeto User a partir de un DocumentSnapshot
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot["email"],
      name: snapshot["name"],

      profilePic: snapshot["profilePic"],
      bannerPic: snapshot["bannerPic"],
      uid: snapshot["uid"],
      bio: snapshot["bio"],

    );
  }

  // Método para convertir el objeto User a un mapa (para ser almacenado en Firestore, por ejemplo)
  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "profilePic": profilePic,
        "bannerPic": bannerPic,
        "uid": uid,
        "bio": bio,
      };
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'bio': bio});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required String documentId}) {
  return UserModel(
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    profilePic: map['profilePic'] ?? '',
    bannerPic: map['bannerPic'] ?? '',
    uid: documentId ?? '', 
    bio: map['bio'] ?? '',
  );
}

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode;
  }
}