import 'package:ams/adminpannel/studentdetail.dart';
import 'package:ams/colors.dart';
import 'package:ams/startingscren.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../studentpannel/studentmodel.dart';
import 'adminfunctions.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Studentmodel> studentrecord = [];
  late Map<String, dynamic> studentname;
  bool leavestatus = false;
  var numberOfLeaves;
//these methods grab full collection
  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection("Students").get();
    mapRecords(records);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _records = records.docs
        .map(
          (item) => Studentmodel(
            id: item.id,
            studentName: item['student name'],
            Email: item['Email'],
            numberofabsents: item['number of absents'],
            numberofleaves: item['number of leaves'],
            numberofpresents: item['number of presents'],
            leavestatus: item['leave status'],
          ),
        )
        .toList();
    setState(() {
      studentrecord = _records;
    });
  }

  showLoggedoutMessaage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Logged Out",
          color: Colors.redAccent,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  showleavemessaage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "You Have ${numberOfLeaves} Leave Requests ",
          color: Colors.redAccent,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void showLeaveMessage() {
    if (numberOfLeaves != 0) {
      showleavemessaage();
    }
  }

// function check the number of req in admin collection and then show snack bar about leaves
  void checkLeaveReq() async {
    final adminID = await FirebaseAuth.instance.currentUser!.uid;
    var records =
        await FirebaseFirestore.instance.collection("Admin").doc(adminID).get();
    Map<String, dynamic>? doc = records.data();
    var _numberofleaves = doc!['Number of Leave Requests'];
    setState(() {
      numberOfLeaves = _numberofleaves;
      print(numberOfLeaves);
    });
    leaveStatus();
    showLeaveMessage();
  }

  void leaveStatus() {
    if (numberOfLeaves != 0) {
      setState(() {
        leavestatus = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchRecords();
    checkLeaveReq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                showLoggedoutMessaage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => startingscreen(),
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app))
        ],
        elevation: 1,
        backgroundColor: scaffoldColor,
        centerTitle: true,
        title: const Text(
          "DashBoard",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: ListView.builder(
        itemCount: studentrecord.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: Color(0xff00bfff)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetail(
                        studentmodel: studentrecord[index],
                      ),
                    ),
                  );
                },
                title: Text(
                  studentrecord[index].studentName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.white),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Leave Status: " + studentrecord[index].leavestatus,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdminBottomNavigaton extends StatefulWidget {
  final void Function()? ontap;
  final Color color;
  final String text;
  const AdminBottomNavigaton(
      {super.key,
      required this.ontap,
      required this.color,
      required this.text});

  @override
  State<AdminBottomNavigaton> createState() => _AdminBottomNavigatonState();
}

class _AdminBottomNavigatonState extends State<AdminBottomNavigaton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
