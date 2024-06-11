import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final Reference eventsStorage =
      FirebaseStorage.instance.ref().child('events');

  Future<String> uploadImageEvents(
      {required File photo, required String title}) async {
    try {
      DateTime dateTime = DateTime.now();
      Reference storageRef = eventsStorage.child(
          '${title.trim()}_${dateTime.millisecondsSinceEpoch}.${photo.path.split('.').last}');
      UploadTask uploadTask = storageRef.putFile(
        photo,
        SettableMetadata(
          contentType: "image/jpeg",
        ),
      );
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (e is FirebaseException) {
        if (e.code == "unauthorized") {
          return "";
        }
      }

      throw 'Error upload image events: $e';
    }
  }
}
