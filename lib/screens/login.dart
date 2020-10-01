import 'package:cartapp/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
  }) : super(key: key);

  @override
  _BLoginState createState() => _BLoginState();
}

class _BLoginState extends State<Login> {
  String uid = '';
  checkuser(FirebaseUser user) async {
    var f;
    try {
      await Firestore.instance
          .collection('MerchantUsers')
          .where('canteenUID', isEqualTo: user.uid)
          .getDocuments()
          .then((value) {
        f = value.documents[0].data['canteenUID'];
        setState(() {
          uid = f;
        });
        print(uid);
      });
    } catch (e) {
      setState(() {
        uid = '';
      });
    }
  }

  Color lColor = Colors.orangeAccent, rColor = Colors.green;
  String email;
  String password;
  Future loginin(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      checkuser(user.user);
      if (uid == user.user.uid)
        return 2;
      else
        return 1;
    } catch (error) {
      return 1;
    }
  }

  final _formKey = GlobalKey<FormState>();
  String error = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // bool loading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'h',
              child: Row(
                children: <Widget>[
                  AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Container(
                        height: height,
                        width: 85,
                        color: lColor,
                      )),
                  AnimatedContainer(
                      height: height,
                      width: width - 85,
                      duration: Duration(seconds: 1),
                      child: Container(
                        color: rColor,
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      splashColor: Colors.blue,
                      highlightColor: Colors.blue,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    )
                  ],
                ),
              ),
            ),
            Align(
                child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(110.0, 30.0, 30.0, 0.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
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
                      SizedBox(
                        height: 180,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Enter An Email',
                            // hintStyle: TextStyle(),
                            fillColor: Colors.green[200],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.green[200], width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.green[200], width: 1.0),
                            )),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.green[200],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.green[200], width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: Colors.green[200], width: 1.0),
                          ),
                        ),
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ButtonTheme(
                        minWidth: 130,
                        height: 45,
                        child: RaisedButton(
                            elevation: 0,
                            color: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                // setState(() => loading = true);
                                dynamic result = await loginin(email, password);
                                if (result == 1) {
                                  _showsnackbar();
                                }
                                if (result == null) {
                                  setState(() {
                                    // loading = false;
                                    error = 'Please supply a valid email';
                                  });
                                }
                                if (result == 2) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                }
                              }
                            }),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      FlatButton(
                        child: Text(
                          'Not Yet Registered ? Sign In',
                          style: TextStyle(fontSize: 15),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
_showsnackbar() {
  final snackBar = new SnackBar(
    content: new Text('Wrong Email or Password'),
    duration: new Duration(seconds: 3),
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}
