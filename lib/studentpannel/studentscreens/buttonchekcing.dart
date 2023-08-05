import 'dart:io';

import 'package:ams/studentpannel/studentlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'studenthome.dart';

class buttonchecking extends StatefulWidget {
  const buttonchecking({Key? key}) : super(key: key);

  @override
  State<buttonchecking> createState() => _buttoncheckingState();
}

class _buttoncheckingState extends State<buttonchecking> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String date = "";
  bool buttonshow = true;
  String selectedFilename = "";
  String filename = "";
  var file;
  final storage = FirebaseStorage.instance;
  String imageURL = "";
  bool filenaemset = false;
  buttoncheck() {
    if (date ==
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        )) {
      setState(
        () {
          buttonshow = false;
        },
      );
    }
  }

  void pickUploadProfilePic() async {
    file = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(file.name);
    setState(() {
      selectedFilename = file.name;
      filename = file.path;
      filenaemset = true;
    });
    print(filename);
  }

  void uploadfile() async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef
        .child("studentpics")
        .child("/" + userid)
        .child("profilepics");
    File file = File(filename);
    mountainsRef.putFile(file);
    try {
      await mountainsRef.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void imageurl() async {
    String downloadURL = await FirebaseStorage.instance
        .ref()
        .child("studentpics")
        .child(userid)
        .child("profilepics")
        .getDownloadURL();
    print(downloadURL);
    setState(() {
      imageURL = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    date = DateFormat("yyyy-MM-dd").format(
                      DateTime.now(),
                    );
                  },
                );
                print(date);
              },
              child: Text("date update"),
            ),
            !buttonshow
                ? attandancecontainer(color: Colors.blueAccent, text: "Present")
                : Text("Todays attandance has been marked"),
            filenaemset
                ? Container(
                    height: 150,
                    width: 150,
                    child: Image.file(File(filename)),
                  )
                : Container(
                    height: 150,
                    width: 150,
                    child: SvgPicture.asset("assets/student.svg"),
                  ),
            ElevatedButton(
              onPressed: () {
                pickUploadProfilePic();
              },
              child: Text("select picture"),
            ),
            ElevatedButton(
              onPressed: () {
                uploadfile();
              },
              child: Text("ipload picture"),
            ),
            ElevatedButton(
              onPressed: () {
                imageurl();
              },
              child: Text("imageurl"),
            ),
            Container(
              height: 200,
              width: 200,
              child: Image.network(imageURL),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().whenComplete(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const studentlogin()),
                      ),
                    );
              },
              child: Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
