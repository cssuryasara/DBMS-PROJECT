import 'package:cartapp/services/database_upload.dart';
// import 'package:cartapp/services/profieservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orders extends StatefulWidget {
  Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  availableDiaglog(BuildContext context, String id) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delivered?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Is the Item Delivered',
              style: TextStyle(
                letterSpacing: -1,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await DatabaseService().delivered(id,true);
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await DatabaseService().delivered(id,false);
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // bool i = true;
    // var time = DateTime.now();
    final height = MediaQuery.of(context).size.height;
    final String assetName2 = 'assets/icon.svg';
    Widget nonVeg1 = SvgPicture.asset(
      assetName2,
      width: width,
      height: height / 1.4,
    );
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Corders')
              .where('canteenUID', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final orders = snapshot.data.documents;
            // DatabaseService().f();
            if (snapshot.data.documents.length == 0) {
              return Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    nonVeg1,
                    Text(
                      "NO ORDERS YET!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              return ListView(
                // diameterRatio: 2.5,
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                // useMagnifier: true,
                // magnification: 1.1,
                // offAxisFraction: -.5,
                itemExtent: height / 4,
                children: List.generate(
                  snapshot.data.documents.length,
                  (int index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onLongPress: () {
                        print('hi');
                        availableDiaglog(context, orders[index]['orderID']);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                        height: height / 10,
                        width: width - width / 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Order NO :',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orders[index]['orderID'],
                                  // .toString()
                                  // .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),  Row(
                              children: <Widget>[
                                Text(
                                  'time of order :',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orders[index]['orderTime'].toDate().toString(),
                                  // .toString()
                                  // .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(' Items',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                orders[index].data['totalCount'],
                                (ind) => Text(
                                  " ${orders[index]['itemName'][ind]} * ${orders[index]['itemCount'][ind]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text('Payement Method :',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  orders[index]['paymentMethod'].toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Price',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      Text('\$',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          orders[index]
                                              .data['totalPrice']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )
                                ])
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: orders[index].data['isDelivered']
                              ? LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    const Color(0xff00FF00),
                                    const Color(0xFF098332)
                                  ], // whitish to gray
                                  // repeats the gradient over the canvas
                                )
                              : LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    const Color(0xffFFFF00),
                                    const Color(0xFFFF7A00)
                                  ], // whitish to gray
                                  // repeats the gradient over the canvas
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Text('data');
          }),
    );
  }
}
/*final orders = snapshot.data.documents;
           }*/
