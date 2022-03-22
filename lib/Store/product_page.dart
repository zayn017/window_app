
import 'package:flutter/material.dart';
import 'package:window_app/Store/storehome.dart';

import '../Models/item.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/myDrawer.dart';


class ProductPage extends StatefulWidget
{
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage>
{
  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: const SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),

                          Text(
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),

                          Text(
                            "€ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()=> checkItemInCart(widget.itemModel.shortInfo, context),
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
                            child: Text("Add Service to Cart", style: TextStyle(color: Colors.white),),
                          ),
                        ),
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

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);