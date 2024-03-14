import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: FirebaseStorage.instance,
    auth: FirebaseAuth.instance,
  );
});

class StorageAPI {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  StorageAPI({required FirebaseStorage storage, required FirebaseAuth auth})
      : _storage = storage,
        _auth = auth;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];

    for (final file in files) {
      try {
        final String userId = _auth.currentUser?.uid ?? 'unknown_user';
        final String childName = 'images/$userId'; // You can customize the childName as needed

        // Using the method from the first code for uploading images
        final downloadUrl = await uploadImageToStorage(childName, file.readAsBytesSync(), false);

        imageLinks.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return imageLinks;
  }

  // Method from the first code for uploading images
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
