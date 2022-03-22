
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:window_app/global/global.dart';

import '../Authentication/authenication.dart';
import '../Config/config.dart';
import '../Store/Search.dart';
import '../Store/cart.dart';
import '../Store/storehome.dart';

class MyDrawer extends StatelessWidget {
  Color color1 =  const Color.fromARGB(128, 208, 199, 1);
  Color color2 =  const Color.fromARGB(19, 84, 122, 1);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.teal],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(18.0)),
                  elevation: 8.0,
                  child: SizedBox(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        sharedPreferences.getString(WindowApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Text(
                  sharedPreferences.getString(WindowApp.userName),
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0,),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.teal],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white,),
                  title: const Text("Home",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),

                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.white,),
                  title: const Text("My Orders",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),

                ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Colors.white,),
                  title: const Text("My Cart",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),
                
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),

                ListTile(
                  leading: const Icon(Icons.add_location, color: Colors.white,),
                  title: const Text("Add New Address",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),

                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.white,),
                  title: const Text("Logout",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    var auth = FirebaseAuth.instance;
                    auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c) => AuthenticScreen() );
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                const Divider(height: 10.0, color: Colors.white, thickness: 6.0,),
              ],
            ),
          ),
        ],

      ),
    );
  }
}
