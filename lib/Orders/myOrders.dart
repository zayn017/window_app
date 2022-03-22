import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_app/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.teal],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          centerTitle: true,
          title: Text("My Orders", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),
              onPressed: ()
              {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: WindowApp.firestore
              .collection(WindowApp.collectionUser)
              .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
              .collection(WindowApp.collectionOrders).snapshots(),
          
          builder: (c, snapshot)
          {
            return snapshot.hasData 
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index){
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("Items")
                            .where("shortInfo", whereIn: snapshot.data.docs[index].data()[WindowApp.productID])
                            .get(),

                        builder: (c, snap)
                        {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderID: snapshot.data.docs[index].id,
                                )
                              : Center(child: circularProgress(),);
                        },
                      );
                    },
                  ) 
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
