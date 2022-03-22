import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:window_app/Config/config.dart';
import 'package:window_app/Store/storehome.dart';

import '../Address/address.dart';
import '../Admin/adminOrderCard.dart';
import '../Counters/cartitemcounter.dart';
import '../Counters/totalMoney.dart';
import '../Models/item.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}



class _CartPageState extends State<CartPage>
{
  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          if(WindowApp.sharedPreferences.getStringList(WindowApp.userCartList).length == 1)
          {
            Fluttertoast.showToast(msg: "your Cart is empty.");
          }
          else
          {
            Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: const Text("Check Out"),
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: ₱ ${amountProvider.totalAmount.toString()}",
                    style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: WindowApp.firestore.collection("Items")
                .where("shortInfo", whereIn: WindowApp.sharedPreferences.getStringList(WindowApp.userCartList)).snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data.docs.isEmpty
                  ? beginBuildingCart()
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index)
                  {
                    ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());

                    if(index == 0)
                    {
                      totalAmount = 0;
                      totalAmount = model.price + totalAmount;
                    }
                    else
                    {
                      totalAmount = model.price + totalAmount;
                    }

                    if(snapshot.data.docs.length - 1 == index)
                    {
                      WidgetsBinding.instance.addPostFrameCallback((t) {
                        Provider.of<TotalAmount>(context, listen: false).display(totalAmount);
                      });
                    }

                    return sourceInfo(model, context, removeCartFunction: () => removeItemFromUserCart(model.shortInfo));
                  },

                  childCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart()
  {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: SizedBox(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.insert_emoticon, color: Colors.white,),
              Text("Cart is empty."),
              Text("Start adding items to your Cart."),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(String shortInfoAsId)
  {
    List tempCartList = WindowApp.sharedPreferences.getStringList(WindowApp.userCartList);
    tempCartList.remove(shortInfoAsId);

    WindowApp.firestore.collection(WindowApp.collectionUser)
        .doc(WindowApp.sharedPreferences.getString(WindowApp.userUID))
        .update({
      WindowApp.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Removed Successfully.");

      WindowApp.sharedPreferences.setStringList(WindowApp.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}
