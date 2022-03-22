
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:window_app/Config/config.dart';
import 'package:window_app/main.dart';

import '../Counters/cartitemcounter.dart';

class PaymentPage extends StatefulWidget
{
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount,}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.teal],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.teal,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: ()=> addOrderDetails(),
                child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      WindowApp.addressID: widget.addressId,
      WindowApp.totalAmount: widget.totalAmount,
      "orderBy": WindowApp.sharedPreferences.getString(WindowApp.userUID),
      WindowApp.productID: WindowApp.sharedPreferences.getStringList(WindowApp.userCartList),
      WindowApp.paymentDetails: "Cash on Delivery",
      WindowApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      WindowApp.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      WindowApp.addressID: widget.addressId,
      WindowApp.totalAmount: widget.totalAmount,
      "orderBy": WindowApp.sharedPreferences.getString(WindowApp.userUID),
      WindowApp.productID: WindowApp.sharedPreferences.getStringList(WindowApp.userCartList),
      WindowApp.paymentDetails: "Cash on Delivery",
      WindowApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      WindowApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  emptyCartNow()
  {
    WindowApp.sharedPreferences.setStringList(WindowApp.userCartList, ["garbageValue"]);
    List tempList = WindowApp.sharedPreferences.getStringList(WindowApp.userCartList);

    FirebaseFirestore.instance.collection("users")
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
        .update({
      WindowApp.userCartList: tempList,
    }).then((value)
    {
      WindowApp.sharedPreferences.setStringList(WindowApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(msg: "Congratulations, your Order has been placed successfully.");

    Route route = MaterialPageRoute(builder: (c) => MyApp());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await WindowApp.firestore.collection(WindowApp.collectionUser)
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
        .collection(WindowApp.collectionOrders)
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID) + data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async
  {
    await WindowApp.firestore
        .collection(WindowApp.collectionOrders)
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID) + data['orderTime'])
        .set(data);
  }
}
