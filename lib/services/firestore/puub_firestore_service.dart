import 'package:cloud_firestore/cloud_firestore.dart';

class PuubFirestoreService {
  static Stream<QuerySnapshot> pubStream(double lat1, double lat2) {
    return Firestore.instance
        .collection('pubs')
        .where('latitute', isGreaterThan: lat1, isLessThan: lat2)
        .snapshots();
  }
}
