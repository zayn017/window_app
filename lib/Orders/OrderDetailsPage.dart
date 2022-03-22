
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Address/address.dart';
import '../Config/config.dart';
import '../Models/address.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import '../main.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget
{
  final String orderID;

  OrderDetails({Key key, this.orderID,}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: WindowApp.firestore
                    .collection(WindowApp.collectionUser)
                    .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
                    .collection(WindowApp.collectionOrders)
                    .doc(orderID)
                    .get(),
            builder: (c, snapshot)
            {
              Map dataMap;
              if(snapshot.hasData)
              {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData 
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(status: dataMap[WindowApp.isSuccess],),
                          SizedBox(height: 10.0,),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "€ " + dataMap[WindowApp.totalAmount].toString(),
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Ordered at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                              style: TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(height: 2.0,),
                          FutureBuilder<QuerySnapshot>(
                            future: WindowApp.firestore
                                .collection("Items")
                                .where("shortInfo", whereIn: dataMap[WindowApp.productID])
                                .get(),
                            builder: (c, dataSnapshot)
                            {
                              return dataSnapshot.hasData 
                                  ? OrderCard(
                                      itemCount: dataSnapshot.data.docs.length,
                                      data: dataSnapshot.data.docs,
                                    ) 
                                  : Center(child: circularProgress(),);
                            },
                          ),
                          Divider(height: 2.0,),
                          FutureBuilder<DocumentSnapshot>(
                            future: WindowApp.firestore
                                .collection(WindowApp.collectionUser)
                                .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
                                .collection(WindowApp.subCollectionAddress)
                                .doc(dataMap[WindowApp.addressID])
                                .get(),
                            builder: (c, snap)
                            {
                              return snap.hasData 
                                  ? ShippingDetails(model: AddressModel.fromJson(snap.data.data()),)
                                  : Center(child: circularProgress(),);
                            },
                          ),
                        ],
                      ),
                    ) 
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}



class StatusBanner extends StatelessWidget
{
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.teal],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
            {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class ShippingDetails extends StatelessWidget
{
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Text(
            "Shipment Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [

              TableRow(
                  children: [
                    KeyText(msg: "Name",),
                    Text(model.name),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Phone Number",),
                    Text(model.phoneNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Flat Number",),
                    Text(model.flatNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "City",),
                    Text(model.city),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "State",),
                    Text(model.state),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Pin Code",),
                    Text(model.pincode),
                  ]
              ),

            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                confirmedUserOrderReceived(context, getOrderId);
              },
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: const Center(
                  child: Text(
                    "Confirmed || Items Received",
                    style: TextStyle(color: Colors.white, fontSize: 15.0,),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext context, String mOrderId)
  {
    WindowApp.firestore
        .collection(WindowApp.collectionUser)
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
        .collection(WindowApp.collectionOrders)
        .doc(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => MyApp());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order has been Received. Confirmed.");
  }
}

