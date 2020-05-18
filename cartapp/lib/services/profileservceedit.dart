import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartapp/services/profileUserdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseeditService {
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

  Stream<ProfileUserData>  userData(FirebaseUser user) {
    return datacollection1.document(user.uid).snapshots().map(_userDataFromSnapshot);
  }
}