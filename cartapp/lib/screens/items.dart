// import 'package:cartapp/widget/additem.dart';
// import 'package:cartapp/widget/edititem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cartapp/screens/home.dart';
// import 'package:merchant/add.dart';
import 'package:provider/provider.dart';
import 'package:cartapp/services/food.dart';
import 'package:cartapp/services/database_upload.dart';

import 'edititem.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

String deletedname = '';
bool isEdit = false;
deleteDiaglog(BuildContext context, String id) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you Sure You Want To Delete',
            style: TextStyle(
              letterSpacing: -1,
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await DatabaseService().delete(id);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _showsnackbar();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        );
      });
}

availableDiaglog(BuildContext context, String id) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Availability',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Is the Item Available',
            style: TextStyle(
              letterSpacing: -1,
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await DatabaseService().available(id,true);
                },
                child: Text(
                  'YES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            FlatButton(
                onPressed: () async{
                  Navigator.pop(context);
                    await DatabaseService().available(id,false);
                  // _showsnackbar();
                },
                child: Text(
                  'NO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        );
      });
}

class _ItemsState extends State<Items> {
  IconData s = Icons.add_circle;
  bool f = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final foods = Provider.of<List<Food>>(context);

    return Scaffold(
      //  key: _scaffoldKey,
      body: foods.length != 0
          ? Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: Image.asset(
                    'assets/bac.jpg',
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                ListView(
                  // scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: List.generate(
                    foods.length,
                    (int index) => Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: GestureDetector(
                        onDoubleTap: () async {
                          setState(() {
                            f = false;
                            s = f ? Icons.close : Icons.add_circle;
                            // deletedname = foods[index].fname;
                          });
                          availableDiaglog(context, foods[index].id);
                        },
                        onLongPress: () async {
                          setState(() {
                            f = false;
                            s = f ? Icons.close : Icons.add_circle;
                            deletedname = foods[index].fname;
                          });
                          deleteDiaglog(context, foods[index].id);
                        },
                        onTap: () {
                          if (isEdit) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Additem1Widget(food: foods[index]),
                              ),
                            );
                          }
                          setState(() {
                            isEdit = false;
                            f = false;
                            s = f ? Icons.close : Icons.add_circle;
                          });
                        },
                        child: Card(
                          color: foods[index].isAvailable
                              ? Colors.white
                              : Colors.white.withOpacity(0.8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Itemcard(
                              // gradient: gradient,
                              index: index,
                              foods: foods[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              height: height,
              // color: Colors.w,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (ctx) => Home()));
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      size: width / 2,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Add Item',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                AbsorbPointer(
                  absorbing: !f,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        f = false;
                        s = f ? Icons.close : Icons.add_circle;
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        height: f ? 60 : 0,
                        width: f ? 60 : 0,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                            color: !f ? Colors.transparent : Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(Icons.add,
                            size: 30,
                            color: !f ? Colors.transparent : Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AbsorbPointer(
                  absorbing: !f,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEdit ? isEdit = false : isEdit = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      height: f ? 60 : 0,
                      width: f ? 60 : 0,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(Icons.edit,
                          color: !f ? Colors.transparent : Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                AbsorbPointer(
                  absorbing: foods.length == 0,
                  child: FloatingActionButton(
                    backgroundColor: foods.length != 0
                        ? Color(0xFFFF6400)
                        : Color(0xffeaeaea),
                    elevation: foods.length != 0 ? 8 : 0,
                    onPressed: () {
                      setState(() {
                        f = f ? false : true;
                        s = f ? Icons.close : Icons.add_circle;
                      });
                    },
                    child: Icon(
                      s,
                      size: 30,
                      color:
                          foods.length != 0 ? Colors.white : Color(0xffeaeaea),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Itemcard extends StatelessWidget {
  const Itemcard({
    Key key,
    // @required this.gradient,
    @required this.index,
    @required this.foods,
  }) : super(key: key);

  // final List<Gradient> gradient;

  final int index;
  final Food foods;

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/veg.svg';
    Widget veg = SvgPicture.asset(
      assetName,
      width: 12,
      height: 12,
    );
    final String assetName2 = 'assets/nonveg.svg';
    Widget nonVeg = SvgPicture.asset(
      assetName2,
      width: 12,
      height: 12,
    );
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: !foods.isveg
                        ? Colors.red.withOpacity(0.8)
                        : Colors.green.withOpacity(0.8),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(foods.image),
                    ),
                    // backgroundColor: Colors.blueAccent,
                  ),
                  // ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Spacer(),
                    Row(
                      children: <Widget>[
                        Spacer(),
                        if (foods.isveg == true) ...[veg],
                        if (foods.isveg == false) ...[nonVeg],
                        Spacer(),
                        Text(
                          foods.fname,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),

                    Text(
                      'Rs ${foods.price.toString()}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      foods.desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    )
                    // Spacer(),
                  ],
                ),
              )
            ]),
        if (isEdit == true) ...[
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
