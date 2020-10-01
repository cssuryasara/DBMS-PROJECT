// import 'package:cartapp/services/profieservices.dart';
// import 'dart:html';

import 'package:cartapp/screens/blogin.dart';
import 'package:flutter/material.dart';
import 'package:cartapp/services/database.dart';
import 'package:cartapp/services/food.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'items.dart';
import 'orders.dart';
import 'profile.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Food>>.value(
      value: DatabasedService().items(user),
      child: DefaultTabController(
        length: 3,
        child: Somethingh(),
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class Somethingh extends StatelessWidget {
  const Somethingh({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          child: IconButton(
              onPressed: () {
                // _auth.signOut();
                Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => BLogin()));
                });
              },
              icon: Icon(Icons.exit_to_app),
              color: Colors.black),
          message: 'Log out',
        ),
        bottom: TabBar(
          indicatorWeight: 3.0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              child: Text(
                'Items'.toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
                child: Text(
              'orders'.toUpperCase(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
            Tab(
                child: Text(
              'profile'.toUpperCase(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
          ],
        ),
        title: Text(
          "Foody'z",
          style: TextStyle(
              fontFamily: 'Pacifico', fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: TabBarView(children: [
        Items(),
        Orders(),
        Profile(),
      ]),
    );
  }
}
