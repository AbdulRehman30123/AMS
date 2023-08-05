import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../studentpannel/studentscreens/studentprofile.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final adminId = FirebaseAuth.instance.currentUser!.uid;
  String adminName = "";
  String adminEmail = "";
  int leaveReq = 0;
  int adminAge = 0;

  void _getAdminDetails() async {
    var _adminDetail =
        await FirebaseFirestore.instance.collection("Admin").doc(adminId).get();
    Map<String, dynamic>? record = _adminDetail.data();
    var _adminName = record!['Name'];
    var _adminEmail = record['Email'];
    var _leaveReq = record['Number of Leave Requests'];
    var _adminAge = record['Age'];
    List<Map<String, dynamic>> studentRecords = [];
    setState(() {
      adminName = _adminName;
      adminEmail = _adminEmail;
      leaveReq = _leaveReq;
      adminAge = _adminAge;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _getAdminDetails();

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
            Container(
              height: 150,
              width: 150,
              child: CircleAvatar(),
            ),
            detailcontainer(
              text: adminName,
            ),
            detailcontainer(text: "Email : " + adminEmail),
            detailcontainer(text: "Age : " + adminAge.toString() + " Years"),
            detailcontainer(
                text: "Total Leave Requests :" + leaveReq.toString()),
          ],
        ),
      ),
    );
  }
}
