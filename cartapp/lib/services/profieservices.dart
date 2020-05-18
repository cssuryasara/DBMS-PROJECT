// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartapp/services/profileUserdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // collection reference
  final CollectionReference datacollection1 =
      Firestore.instance.collection('MerchantUsers');

  ProfileUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return ProfileUserData(
      email: snapshot.data['email'] ?? '',
      canteenName: snapshot.data['canteenName'] ?? '',
      colllegeName: snapshot.data['collegeName'] ?? '',
      image: snapshot.data['canteenImage'] ?? '',
    );
  }

  // getlength() async {
  //   return await Firestore.instance
  //       .collection('Corders')
  //       .where('canteenUID', isEqualTo: '1234')
  //       .snapshots()
  //       .length;
  // }
   Stream getlength(FirebaseUser user) {
    return Firestore.instance
        .collection('Corders')
        .where('canteenUID', isEqualTo: user.uid)
        .snapshots();
       
  }
  Stream<ProfileUserData> userData(FirebaseUser user) {
    return datacollection1
        .document(user.uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
