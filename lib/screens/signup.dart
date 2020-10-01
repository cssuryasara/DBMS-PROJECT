// import 'dart:html';

// import 'package:cartapp/screens/login.dart';
import 'package:cartapp/screens/sign2.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

Color lColor = Colors.orangeAccent, rColor = Colors.green;

class _SignupState extends State<Signup> {
  String email;
  String password;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  AuthResult signedInUser;

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 2;
    } catch (error) {
      if (error is PlatformException) {
        if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return 1;
        }
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showsnackbar() {
    final snackBar = new SnackBar(
      content: new Text('email already exist'),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // final error = Provider.of<Failure>(context).errorMessage;
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
                          width: width - 85,
                          color: lColor,
                        )),
                    AnimatedContainer(
                        height: height,
                        width: 85,
                        duration: Duration(seconds: 1),
                        child: Container(
                          color: rColor,
                        )),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
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
                      height: 140.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 10.0, 100.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: 'Enter An Email',
                                  fillColor: Colors.orange[200],
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          color: Colors.orange[200], width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.orange[200], width: 2.0),
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
                              textAlign: TextAlign.right,
                              obscureText: true,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                // err
                                fillColor: Colors.orange[200],
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.orange[200], width: 1.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.orange[200], width: 1.0),
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
                              // buttonColor: Colors.greenAccent,

                              child: RaisedButton(
                                  color: Colors.greenAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),
                                  ),
                                  child: Text(
                                    'Signup',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result =
                                          await registerWithEmailAndPassword(
                                              email, password);
                                      if (result == 1) {
                                        _showsnackbar();
                                      }
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error = 'Please supply a valid email';
                                        });
                                      }
                                      if (result == 2) {
                                        // Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signin2()),
                                        );
                                      }
                                    }
                                  }
                                  // },
                                  ),
                            ),
                            RaisedButton(onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin2()),
                              );
                            }),
                            SizedBox(
                              height: 16,
                            ),
                            FlatButton(
                              child: Text(
                                'Already User ? Login ',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
// class _SignInState extends State<SignIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange,
//       body: Wrap(
//         children: <Widget>[

//         ],
//       ),
//     );
//   }
// }
