import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admin/adminLogin.dart';
import '../DialogBox/errorDialog.dart';
import '../DialogBox/loadingDialog.dart';
import '../Store/storehome.dart';
import '../Widgets/customTextField.dart';
import '../global/global.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset("img/login.png",
                height: 240.0,
                width: 240.0,),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login to your account",
                style: TextStyle(color: Colors.cyan,fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                _emailTextEditingController.text.isNotEmpty &&
                    _passwordTextEditingController.text.isNotEmpty ? loginUser()
                    : showDialog(
                  context: context,
                  builder: (c){
                    return const ErrorAlertDialog(message: "Please write Email and Password",);
                  }
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Login", style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.cyan,
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextButton.icon(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      AdminSignInPage())),
                icon: const Icon(Icons.account_circle_rounded, color: Colors.black45),
                label: const Text("I'm Admin",
                    style: TextStyle(color: Colors.cyan,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  User firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser()async{
    showDialog(
      context: context,
      builder: (c){
        return LoadingAlertDialog(message: "Authenticating, Please wait...",);
      }
    );
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });
    if(firebaseUser != null){
      readData(firebaseUser).then((s){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences.setString("userUID", currentUser.uid);
      await sharedPreferences.setString("email", currentUser.email.toString());
      await sharedPreferences.setString("userImage", snapshot.data()["url"]);
      await sharedPreferences.setString("name", snapshot.data()["name"]);
      await sharedPreferences.setStringList("userCart", ["garbageValue"]);
    });
  }
}
