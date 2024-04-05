import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/models/art.dart';

class DatabaseService {
  late final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userFavourite =
      FirebaseFirestore.instance.collection('fav art');

  Future updateUserData(Art art) async {
    return await userFavourite.doc(uid).update({
      'art': FieldValue.arrayUnion([art.toMap()]),
    });
  }

  Future deleteUserData(Art art) async {
    return await userFavourite.doc(uid).update({
      'art': FieldValue.arrayRemove([art.toMap()])
    });
  }

  Future createEmptyList() async {
    userFavourite.doc(uid).set({'art': []});
  }
}
