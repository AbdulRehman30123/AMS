import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  String Email = "";
  int presents = 0;
  int leaves = 0;
  int absents = 0;
  String leaveStatus = "";
  String imageURL = "";
  bool imageURLSet = false;
  void _getUserDetails() async {
    var _doc = await FirebaseFirestore.instance
        .collection("Students")
        .doc(userid)
        .get();
    Map<String, dynamic>? data = _doc.data();
    var _username = data!['student name'];
    var _Email = data['Email'];
    var _presents = data['number of presents'];
    var _absents = data['number of absents'];
    var _leaves = data['number of leaves'];
    var _leavestatus = data['leave status'];
    setState(
      () {
        userName = _username;
        Email = _Email;
        presents = _presents;
        leaves = _leaves;
        absents = _absents;
        leaveStatus = _leavestatus;
      },
    );
    print(leaveStatus);
  }

// get profile image from firestore
  void imageurl() async {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    String downloadURL = await FirebaseStorage.instance
        .ref()
        .child("studentpics")
        .child(userid)
        .child("profilepics")
        .getDownloadURL();
    print(downloadURL);
    setState(() {
      imageURL = downloadURL;
      imageURLSet = true;
    });
  }

//update imageurl in main collection
  void updateImageUrl() async {
    final _imageurl =
        await FirebaseFirestore.instance.collection("Students").doc(userid);
    _imageurl.update({"image url": imageURL});
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserDetails();
    imageurl();
    updateImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3cee5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageURLSet
                ? Container(
                    height: 150,
                    width: 150,
                    child: Container(
                      child: Image.network(imageURL),
                    ),
                  )
                : Container(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(),
                  ),
            detailcontainer(
              text: userName,
            ),
            detailcontainer(text: Email),
            detailcontainer(text: "Total Presents: $presents"),
            detailcontainer(text: "Total Absents: $absents"),
            detailcontainer(text: "Total Leaves: $leaves"),
            detailcontainer(text: "Leave Status: $leaveStatus"),
          ],
        ),
      ),
    );
  }
}

class detailcontainer extends StatefulWidget {
  final text;
  const detailcontainer({super.key, required this.text});

  @override
  State<detailcontainer> createState() => _detailcontainerState();
}

class _detailcontainerState extends State<detailcontainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 15)
          ],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xfff0f8ff),
        ),
        height: 50,
        child: Text(
          widget.text,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
