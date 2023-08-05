import 'dart:io';

import 'package:ams/studentpannel/studentlogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'studentfunctions/studentfucntions.dart';

class studentsignup extends StatefulWidget {
  const studentsignup({Key? key}) : super(key: key);

  @override
  State<studentsignup> createState() => _studentsignupState();
}

class _studentsignupState extends State<studentsignup> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _studentName = TextEditingController();
  // thi sfunction will create user with email and passwords
  void createuser() async {
    final credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .then((value) => storeStudentData());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => studentlogin()),
    );
  }

//this will store all details of user
  void storeStudentData() async {
    final _uid = await FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Students").doc(_uid).set(
      {
        "student name": _studentName.text.trim(),
        "Email": _emailController.text.trim(),
        "number of leaves": 0,
        "number of absents": 0,
        "number of presents": 0,
        "password": _passwordController.text.trim(),
        "leave status": "null",
        "marked on": "null",
        "image url": ""
      },
    ).whenComplete(() => uploadfile());
    // then((value) => attandancerecord());
  }

  showSignedUpMessaage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Signed Up",
          color: Colors.green,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // to upload pictures in firestore

  String date = "";
  bool buttonshow = true;
  String selectedFilename = "";
  String filename = "";
  var file;
  final storage = FirebaseStorage.instance;
  String imageURL = "";
  bool filenameset = false;
  void pickUploadProfilePic() async {
    file = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(file.name);
    setState(() {
      selectedFilename = file.name;
      filename = file.path;
      filenameset = true;
    });
    print(filename);
  }

  void uploadfile() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3cee5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              (const SizedBox(
                height: 40,
              )),
              Container(
                height: 150,
                width: 200,
                child: SvgPicture.asset('assets/undraw_welcome_cats_thqn.svg'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              //for getting user email
              textfield(controller: _emailController, hinttext: "Email"),
              const SizedBox(
                height: 10.0,
              ),
              //for getting user password
              textfield(controller: _passwordController, hinttext: "Password"),
              const SizedBox(
                height: 10.0,
              ),
              //for getting student name
              textfield(controller: _studentName, hinttext: "Name"),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  filenameset
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40)),
                          height: 200,
                          width: 200,
                          child: Image.file(File(filename)),
                        )
                      : Container(),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: pickUploadProfilePic,
                        child: loginsignupbutton(
                          hinttext: "Chose Image",
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  createuser();
                },
                child: const loginsignupbutton(
                  hinttext: "Signup",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const signupline(
                text1: "This might take some Time  ",
                text2: "Please Wait",
              )
            ],
          ),
        ),
      ),
    );
  }
}
