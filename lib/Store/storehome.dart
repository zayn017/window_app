import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:window_app/Config/config.dart';
import 'package:window_app/Store/product_page.dart';
import '../Counters/cartitemcounter.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'cart.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          title: const Text(
            "WS",
            style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: "Signatra",letterSpacing: 2),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white,),
                  onPressed: ()
                  {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _)
                          {
                            return Text(
                              // counter?.count?.toString(),
                              (WindowApp.sharedPreferences.getStringList(WindowApp.userCartList).length-1).toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Items").limit(15).orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, dataSnapshot)
              {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    ItemModel model = ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                    return sourceInfo(model, context);
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: ()
    {
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.teal,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 190.0,
        width: width,
        child: Container(
          child: Row(
            children: [
              Image.network(model.thumbnailUrl, width: 160.0, height: 160.0,),
              const SizedBox(width: 4.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.title, style: const TextStyle(color: Colors.black, fontSize: 14.0),),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.shortInfo, style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Row(
                      children: [

                        const SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  const Text(
                                    r" Price: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Text(
                                    "₱ ",
                                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    Flexible(
                      child: Container(),
                    ),

                    //to implement the cart item aad/remove feature
                    Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.teal,),
                        onPressed: ()
                        {
                          checkItemInCart(model.shortInfo, context);
                        },
                      )
                          : IconButton(
                        icon: const Icon(Icons.delete, color: Colors.teal,),
                        onPressed: ()
                        {
                          removeCartFunction();
                          Route route = MaterialPageRoute(builder: (c) => StoreHome());
                          Navigator.pushReplacement(context, route);
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 5.0,
                      color: Colors.teal,
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}



void checkItemInCart(String shortInfoAsID, BuildContext context)
{
  WindowApp.sharedPreferences.getStringList(WindowApp.userCartList).contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
      : addItemToCart(shortInfoAsID, context);
}


addItemToCart(String shortInfoAsID, BuildContext context)
{
  List tempCartList = WindowApp.sharedPreferences.getStringList(WindowApp.userCartList);
  tempCartList.add(shortInfoAsID);

  WindowApp.firestore.collection(WindowApp.collectionUser)
      .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
      .update({
    WindowApp.userCartList: tempCartList,
  }).then((v){
    Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

    WindowApp.sharedPreferences.setStringList(WindowApp.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
