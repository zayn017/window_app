import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_app/splashScreen/splashScreen.dart';

import 'Authentication/authenication.dart';
import 'Config/config.dart';
import 'Counters/ItemQuantity.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'global/global.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  WindowApp.auth = FirebaseAuth.instance;
  WindowApp.sharedPreferences = await SharedPreferences.getInstance();
  WindowApp.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(

          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: MySplashScreen()
      ),
    );
  }
}


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key key}) : super(key: key);

  @override
  _MySplashScreen createState() => _MySplashScreen();
}

class _MySplashScreen extends State<MySplashScreen> {

  displaySplash(){
    Timer(const Duration(seconds: 5), () async{
      if (firebaseAuth.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => StoreHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => AuthenticScreen()),
        );
      }
    });
  }

  @override
  void initState(){
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("img/Spa-services.png",
                width: 200.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Welcome To WindowApp",
                style: TextStyle(
                    color: Colors.white, fontSize: 15.0),textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
