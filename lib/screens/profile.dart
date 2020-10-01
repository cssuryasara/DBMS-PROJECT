import 'package:cartapp/services/profieservices.dart';
import 'package:cartapp/services/profileUserdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return StreamProvider.value(
      value: DatabaseService().userData(user),
      child: Something(),
    );
  }
}

class Something extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ProfileUserData>(context);
    var user1 = Provider.of<FirebaseUser>(context);

    return StreamBuilder(
        stream: DatabaseService().getlength(user1),
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              AnimatedContainer(
                height: double.infinity,
                duration: Duration(milliseconds: 5),
                foregroundDecoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Image.network(
                  // 'https://images.unsplash.com/photo-1508424757105-b6d5ad9329d0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80',
                  user.image,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 30, right: 20.0, bottom: 15.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.canteenName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            letterSpacing: -3,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        user.colllegeName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          letterSpacing: -3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: -3,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(
                        flex: 8,
                      ),
                      Text('Total No Of Orders :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              letterSpacing: -3,
                              fontWeight: FontWeight.bold)),
                      Spacer(
                        flex: 10,
                      ),
                      Center(
                        child: Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              letterSpacing: -3,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(flex: 30),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text('@foodyz',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                letterSpacing: -3,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
