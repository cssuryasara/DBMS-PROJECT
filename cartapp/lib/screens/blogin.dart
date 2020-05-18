import 'package:cartapp/screens/login.dart';
import 'package:cartapp/screens/signup.dart';

import 'package:flutter/material.dart';

class BLogin extends StatefulWidget {
  BLogin({Key key}) : super(key: key);

  @override
  _BLoginState createState() => _BLoginState();
}

class _BLoginState extends State<BLogin> {
  Color lColor = Colors.orangeAccent, rColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    // var user=Provider.of<User>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'h',
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: lColor,
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: rColor,
                  )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child:
                 Text(
                  "Foody'z",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                      fontSize: 50,
                      letterSpacing: -1
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    splashColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => Login()));
                    },
                  ),
                  RaisedButton(
                    splashColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => Signup()));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
