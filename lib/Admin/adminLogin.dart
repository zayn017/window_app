import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:window_app/Admin/uploadItems.dart';

import '../Authentication/authenication.dart';
import '../DialogBox/errorDialog.dart';
import '../Widgets/customTextField.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: TextStyle(fontSize: 25.0, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {


    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("img/login.png",
              height: 240.0,
              width: 240.0,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(color: Colors.white,fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "ID",
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
            const SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
              onPressed: (){
                _adminIDTextEditingController.text.isNotEmpty &&
                    _passwordTextEditingController.text.isNotEmpty ? loginAdmin()
                    : showDialog(
                    context: context,
                    builder: (c){
                      return const ErrorAlertDialog(message: "Please write Email and Password",);
                    }
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 25.0),),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        AuthenticScreen())),
                icon: const Icon(Icons.nature_people, color: Colors.white),
                label: const Text("I'm not Admin",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),
                ),
            ),
            const SizedBox(
              height: 70.0,
            ),
          ],
        ),
      ),
    );

  }
  loginAdmin(){
    FirebaseFirestore.instance.collection("admin").get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()['id'] != _adminIDTextEditingController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your ID is not Correct"),));
        }
        else if(result.data()['password'] != _passwordTextEditingController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Password is not Correct"),));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin, " + result.data()["name"]),));

          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
