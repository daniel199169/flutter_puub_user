import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PuubFirestoreAvatarService {
  PuubFirestoreAvatarService({@required this.uid}) : assert(uid != null);
  final String uid;

  // Sets the avatar download url
  Future<void> setAvatarReference(String avatarReference) async {
    final path = 'avatar/$uid';
    final reference = Firestore.instance.collection('users').document(uid);
    Map m = new Map();
    print('avatarReference ttt '+avatarReference);
    m.putIfAbsent('downloadUrl', () => avatarReference);
    //await reference.setData(m);
    await reference.updateData({
      "downloadUrl":avatarReference,
    });
  }

  // Reads the current avatar download url
  Stream<String> avatarReferenceStream() {
    final path = 'avatar/$uid';
    final reference = Firestore.instance.collection('users').document(uid);
    final snapshots = reference.snapshots();
    print('downloadUrlKKKK '+snapshots.toString());
    return snapshots.map((snapshot) {
      print('downloadUrlKKK456K '+snapshot.data.toString());
      if (snapshot.data == null) {
        return null;
      }
      final downloadUrl = snapshot.data['downloadUrl'];
      
      if (downloadUrl == null) {
        return null;
      }
      return downloadUrl;
    });
  }
}
