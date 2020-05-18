// import 'package:cartapp/services/profileUserdata.dart';
import 'package:cartapp/services/profileUserdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // final CollectionReference items = Firestore.instance.collection('items');
  updateUserData(String fname, String desc, bool isveg, int price, String img,
      FirebaseUser user, String category, ProfileUserData userData) {
    //add category
    Firestore.instance.collection('category').document().setData({
      'canteenName': userData.canteenName,
      'canteenUID': user.uid,
      'categoryName': category
    });
    //addidng food data
    Firestore.instance.collection('food').document().setData({
      'foodName': fname,
      'description': desc,
      'isVeg': isveg,
      'image': img,
      'price': price,
      'isAvailable': true,
      'canteenUID': user.uid,
      'category': category,
      'canteenName': userData.canteenName
    });
  }

  Future editUserData(
      {String fname,
      String desc,
      String img,
      bool isveg,
      int price,
      String id,
      String category}) async {
    final CollectionReference items = Firestore.instance.collection('food');
    return await items.document(id).updateData({
      'food_name': fname,
      'description': desc,
      'veg': isveg,
      'image': img,
      'price': price,
      'category': category,
    });
  }
    Future delete(String docId) async {
    final CollectionReference items = Firestore.instance.collection('food');
    return await items.document(docId).delete();
  }

  Future available(String docId, bool available) async {
    final CollectionReference items = Firestore.instance.collection('food');
    return await items.document(docId).updateData({'isAvailable': available});
  }
Future delivered(String docId, bool available) async {
    final CollectionReference items = Firestore.instance.collection('Corders');
    return await items.document(docId).updateData({'isDelivered': available});
  }

}
