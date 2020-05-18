import 'dart:io';
//hangout

import 'package:cartapp/services/food.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';

import 'package:cartapp/services/database_upload.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Additem1Widget extends StatefulWidget {
  Additem1Widget({@required this.food});
  final Food food;

  @override
  _Additem1WidgetState createState() => _Additem1WidgetState(this.food);
}

enum typefood { veg, nonveg }

class _Additem1WidgetState extends State<Additem1Widget> {
  Food food;
  _Additem1WidgetState(this.food);

  String foodname = '';
  String description = '', catagory = '';
  int price;
  String url;
  String vegn;
  File sampleImage;
  typefood _character = typefood.veg;
  bool b2 = true;
  bool isveg = true;

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
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Text(
                                    'Close',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
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

  Future getImage(ImageSource source) async {
    var tempImage = await ImagePicker.pickImage(source: source);
    setState(() {
      sampleImage = tempImage;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showsnackbar() {
    final snackBar = new SnackBar(
      content: new Text('Text Copied 😎'),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Foody'z",
          style: TextStyle(
              fontFamily: 'Pacifico', fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: AbsorbPointer(
            absorbing: true, child: Icon(Icons.camera, color: Colors.white)),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          splashColor: Colors.blue,
                          highlightColor: Colors.blue,
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6400),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Color(0xFF000000)),
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
                        Spacer(
                          flex: 10,
                        ),
                        Text(
                          'Edit item',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(
                          flex: 90,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    sampleImage == null
                        ? GestureDetector(
                            onTap: showBottomSheet,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 200,
                              width: 200,
                              child: Image.network(
                                food.image,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                        : enableUpload(),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Food_Name',
                        helperText: food.fname,
                        helperStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF6400), width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => foodname = val);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        helperText: food.desc,
                        helperStyle: TextStyle(color: Colors.white),
                        hintText: 'Description',
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF6400), width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => description = val);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          print('object');
                          ClipboardManager.copyToClipBoard(food.desc)
                              .then((result) {
                            _showsnackbar();
                          });
                        },
                        splashColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Copy Above Text',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        helperText: food.price.toString(),
                        // helperText: fo,
                        fillColor: Colors.white,
                        helperStyle: TextStyle(color: Colors.white),
                        filled: true,
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.white, width: 2.0),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF6400), width: 3.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          price = int.parse(val);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        helperText: food.category,
                        fillColor: Colors.white,
                        helperStyle: TextStyle(color: Colors.white),
                        filled: true,
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.white, width: 2.0),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF6400), width: 3.0),
                        ),
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Enter proper catagory' : null,
                      onChanged: (val) {
                        setState(() {
                          catagory = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_character == typefood.veg) {
                            _character = typefood.nonveg;
                            isveg = false;
                          } else {
                            _character = typefood.veg;
                            isveg = true;
                          }
                          b2 ? b2 = false : b2 = true;
                        });
                        // print(widget._character);
                      },
                      child: Container(
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Icon(
                                b2
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Colors.white),
                            Spacer(
                              flex: 4,
                            ),
                            Text('Veg',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Spacer(
                              flex: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_character == typefood.nonveg) {
                            _character = typefood.veg;
                            isveg = true;
                          } else {
                            _character = typefood.nonveg;
                            isveg = false;
                          }
                          b2 ? b2 = false : b2 = true;
                        });
                        // print(widget._character);
                      },
                      child: Container(
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Icon(
                                !b2
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Colors.white),
                            Spacer(
                              flex: 4,
                            ),
                            Text(
                              'Non-Veg',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Spacer(
                              flex: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    if (sampleImage != null) ...[
                      InkWell(
                        // elevation: 7.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFFF6400),
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Upload Image',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // textColor: Colors.white,
                        // color: Colors.blue,
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance.ref().child(foodname);
                            task = firebaseStorageRef.putFile(sampleImage);
                            progressIndicator(context, task);
                            var downurl = await (await task.onComplete)
                                .ref
                                .getDownloadURL();
                            setState(() {
                              url = downurl.toString();
                            });
                            await DatabaseService().editUserData(
                                fname: foodname,
                                desc: description,
                                img: url,
                                price: price,
                                isveg: isveg,
                                id: food.id,
                                category: catagory);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
