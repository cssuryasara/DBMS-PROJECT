// import 'package:cartapp/screens/homepage.dart';
import 'package:cartapp/screens/login.dart';
// import 'package:cartapp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(FirebaseUser user, context, String clg, String ctn, String img) {
    //add to search
    String firstLetter = clg.substring(0, 1).toUpperCase();
    var capitalizedValue = clg.substring(0, 1).toUpperCase() + clg.substring(1);
    Firestore.instance
        .collection('search')
        .document()
        .setData({'collegeName': capitalizedValue, 'searchKey': firstLetter});

//add canteen data
    Firestore.instance.collection('Canteen').document().setData({
      'collegeName': 'Dayananda Sagar College Of Engineering',
      'image': img,
      'canteenUID': user.uid,
      'canteenName': ctn
    });
    //add user data
    Firestore.instance.collection('MerchantUsers').document(user.uid).setData({
      'email': user.email,
      'canteenUID': user.uid,
      'collegeName': clg,
      'canteenName': ctn,
      'canteenImage': img,
    }).then((value) {
      // Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => Login()));
    }).catchError((e) {
      print(e);
    });
  }
}
