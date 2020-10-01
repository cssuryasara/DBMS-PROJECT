import 'package:cartapp/screens/blogin.dart';
// import 'package:cartapp/services/profieservices.dart';
// import 'package:cartapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Make user stream available
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
          
      ],
      child:
      MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: Color(0xffffffff),
              scaffoldBackgroundColor: Color(0xffeaeaea),
              accentColor: Color(0xFFFF6400),
              fontFamily: 'Montserrat'),
          home: BLogin(),
        
      ),
    );
  }
}
