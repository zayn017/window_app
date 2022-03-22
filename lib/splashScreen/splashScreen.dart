import 'dart:async';
import 'package:flutter/material.dart';
import '../Authentication/authenication.dart';
import '../Store/storehome.dart';
import '../global/global.dart';


class MySplashScreen extends StatefulWidget {

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
                "Welcome To washly",
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
