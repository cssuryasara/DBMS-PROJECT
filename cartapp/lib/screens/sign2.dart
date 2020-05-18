
// import 'dart:html';

// import 'package:cartapp/services/database_upload_userdata.dart';
// import 'package:cartapp/services/auth.dart';
import 'package:cartapp/services/database_upload_userdata.dart';
// import 'package:cartapp/services/profieservices.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class Signin2 extends StatefulWidget {
  Signin2({
    Key key,
  }) : super(key: key);

  @override
  _Signin2State createState() => _Signin2State();
}

class _Signin2State extends State<Signin2> {
  Color lColor = Colors.orangeAccent, rColor = Colors.green;
  // _Signin2State(user);
  File sampleImage;
  String collegeName = '';
  String canteenName = '';
  String url;
  var loggeduser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggeduser = user;
      }
    } catch (e) {}
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return Container(
          height: height / 8,
          width: width,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  print('hi');

                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Container(
                  width: width / 2,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[Icon(Icons.camera), Text('Camera')],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print('hi');
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Container(
                  width: width / 2,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(Icons.insert_photo),
                      Text('Gallery')
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource source) async {
    var tempImage = await ImagePicker.pickImage(source: source);
    setState(() {
      sampleImage = tempImage;
    });
  }

  StorageUploadTask task;
  progressIndicator(BuildContext context, StorageUploadTask task) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Uploading',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<StorageTaskEvent>(
                    stream: task.events,
                    builder: (context, snapshot) {
                      var event = snapshot?.data?.snapshot;
                      double progressPercent = event != null
                          ? event.bytesTransferred / event.totalByteCount
                          : 0;
                      return Column(
                        children: <Widget>[
                          CircularPercentIndicator(
                            lineWidth: 15,
                            progressColor: Color(0xFFFF6400),
                            animation: true,
                            radius: 250,
                            percent: progressPercent,
                            center: Text(
                              '${(progressPercent * 100).toStringAsFixed(2)} %',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (task.isInProgress) ...[
                            Text('please wait until we uplaod'),
                          ],
                          if (task.isComplete) ...[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Text(
                                  '🎉🎉',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    //  var user=Provider.of<User>(context);

    return  Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: 'h',
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                    duration: Duration(seconds: 1),
                    child: Container(
                      height: 100,
                      width: width - 85,
                      color: lColor,
                    )),
                AnimatedContainer(
                    height: 100,
                    width: 85,
                    duration: Duration(seconds: 1),
                    child: Container(
                      color: rColor,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Add Profile',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  child: Column(
                    children: <Widget>[
                      sampleImage == null
                          ? GestureDetector(
                              onTap: showBottomSheet,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                height: 200,
                                width: 200,
                                child: Icon(Icons.add_a_photo),
                              ),
                            )
                          : enableUpload(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'canteenName',
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFF6400), width: 2.0),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => canteenName = val);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'collegeName',
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFFF6400), width: 2.0),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => collegeName = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      if (sampleImage != null) ...[
                        RaisedButton(
                          elevation: 7.0,
                          child: Text('Upload Image'),
                          textColor: Colors.white,
                          color: Color(0xFFFF6400),
                          onPressed: () async {
                              String filePath = '$collegeName/$canteenName.png';
                            final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance
                                    .ref()
                                    .child(filePath);
                            task = firebaseStorageRef.putFile(sampleImage);
                            progressIndicator(context, task);
                            var downurl = await (await task.onComplete)
                                .ref
                                .getDownloadURL();
                            setState(() {
                              url = downurl.toString();
                            });
                            await UserManagement().storeNewUser(loggeduser,
                                context, collegeName, canteenName, url);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: showBottomSheet,
            child: Image.file(
              sampleImage,
              height: 100.0,
              width: 100.0,
            ),
          ),
        ],
      ),
    );
  }
}
