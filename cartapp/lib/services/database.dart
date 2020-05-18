// import 'package:cartapp/services/profileUserdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cartapp/services/food.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabasedService {
  final CollectionReference datacollection =
      Firestore.instance.collection('food');

  List<Food> _foodlistfromsnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Food(
        fname: doc.data['foodName'] ?? '',
        desc: doc.data['description'] ?? '',
        image: doc.data['image'] ?? '',
        isveg: doc.data['isVeg'] ?? false,
        price: doc.data['price'] ?? 0,
        category: doc.data['category']??'',
        id: doc.documentID ?? '',
        isAvailable: doc.data['isAvailable'] ?? false,
      );
    }).toList();
  }

  Stream<List<Food>> items(FirebaseUser user) {
    print(user.uid);
    return Firestore.instance
        .collection('food')
        .where('canteenUID', isEqualTo: user.uid)
        .snapshots()
        .map(_foodlistfromsnapshot);
  }
}
