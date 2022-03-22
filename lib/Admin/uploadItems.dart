import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../Widgets/loadingWidget.dart';
import '../splashScreen/splashScreen.dart';
import 'adminShiftOrders.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;

  File imageXFile;
  final ImagePicker _picker = ImagePicker();
  String uploadImageUrl = "";
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return imageXFile == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
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
          style: TextStyle(fontSize: 25, letterSpacing: 2),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => MySplashScreen());
                Navigator.pushReplacement(context, route);
              },
              icon: const Icon(
                Icons.logout,
                size: 25,
              ))
          // TextButton(
          //   child: const Text(
          //     "Logout",
          //     style: TextStyle(
          //         color: Colors.pink,
          //         fontSize: 16.0,
          //         fontWeight: FontWeight.bold),
          //   ),
          //   onPressed: () {
          //     Route route = MaterialPageRoute(builder: (c) => MySplashScreen());
          //     Navigator.pushReplacement(context, route);
          //   },
          // ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () => takeImage(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                ),
                child: const Text(
                  "Add New Items",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: const Text(
              "Add Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: const Text("Select From Gallery with Gallery",
                    style: TextStyle(color: Colors.green)),
                onPressed: _getImageFromGallary,
              ),
              SimpleDialogOption(
                child: const Text("Take Picture with Camera",
                    style: TextStyle(color: Colors.green)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

_getImageFromGallary() async {
    Navigator.pop(context);
    imageXFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFile = (File(imageXFile.path));
    setState(() {
      imageFile;
    });
  }

capturePhotoWithCamera() async {
    Navigator.pop(context);
    imageXFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = (File(imageXFile.path));
    setState(() {
      imageFile;
    });
  }

  displayAdminUploadFormScreen() {
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
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo),
        title: const Text(
          "Adding New Service",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : const Text(""),
          SizedBox(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(imageFile), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _shortInfoTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _titleTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: Colors.indigo),
                controller: _descriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.teal,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.indigo),
                controller: _priceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.teal,
          ),
          // TextButton(
          //   onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
          //   child: const Text(
          //     "Add",
          //     style: TextStyle(
          //         color: Colors.pink,
          //         fontSize: 16.0,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          ElevatedButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add Service",
                style: TextStyle(fontSize: 23.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.push(context, route);
    setState(() {
      imageFile;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadingItemImage(imageXFile);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadingItemImage(mFileImage) async {
    String downloadUrl;
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("Items").child(imageName);
    fStorage.UploadTask uploadTask = reference.putFile(imageFile);
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      uploadImageUrl = url;
    });
    return uploadImageUrl;

    // final FirebaseStorage storageReference =
    //     FirebaseStorage.instance.ref().child("Items") as FirebaseStorage;
    // UploadTask uploadTask =
    //     storageReference.ref("service_$productId.jpg").putFile(mFileImage);
    // TaskSnapshot taskSnapshot = await uploadTask;
    // downloadUrl = await taskSnapshot.ref.getDownloadURL();
    // return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection("Items");
    itemsRef.doc(productId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      // "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
    });

    setState(() {
      imageFile;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });

    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.push(context, route);
  }
}
