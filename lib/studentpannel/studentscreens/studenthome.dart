import 'package:ams/Functions.dart';
import 'package:ams/startingscren.dart';
import 'package:ams/studentpannel/studentlogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../adminpannel/adminfunctions.dart';

class studenthome extends StatefulWidget {
  const studenthome({Key? key}) : super(key: key);

  @override
  State<studenthome> createState() => _studenthomeState();
}

class _studenthomeState extends State<studenthome> {
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdate = DateFormat("HH:mm:ss").format(DateTime.now());
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  String leaveStatus = "";
  bool leave_approved = false;
  bool markedAttandance = false;
  String attandanceDate = "";
  // function to display username
  void getUserDetails() async {
    var _doc = await FirebaseFirestore.instance
        .collection("Students")
        .doc(userid)
        .get();
    Map<String, dynamic>? data = _doc.data();
    var _username = data!['student name'];
    var _leavestatus = data['leave status'];
    var _markedOn = data['marked on'];
    setState(() {
      userName = _username;
      leaveStatus = _leavestatus;
      attandanceDate = _markedOn;
      print(_leavestatus);
      print(_markedOn);
    });
    checkLeaveStatus();
    checkrejectLeaveStatus();
    checkpendingLeaveStatus();
    checkMarkedOn();
  }

  void checkMarkedOn() {
    if (attandanceDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      setState(() {
        markedAttandance = true;
      });
    }
  }

  void checkLeaveStatus() {
    if (leaveStatus == "Approve") {
      setState(() {
        leave_approved = true;
      });
      showleavemessaageaccepted();
    }
  }

  void checkrejectLeaveStatus() {
    if (leaveStatus == "Rejected") {
      showleavemessagerejected();
    }
  }

  void checkpendingLeaveStatus() {
    if (leaveStatus == "pending") {
      showleavemessagpending();
    }
  }

  showleavemessaageaccepted() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Your Leave is Accepted ",
          color: Colors.green,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  showleavemessagerejected() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Your Leave is Rejected ",
          color: Colors.red,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  showleavemessagpending() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Your Leave is Pending ",
          color: Colors.lightBlue,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void attandacemarked() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Today's Attendance Marked "),
          );
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

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    showLoggedoutMessaage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => startingscreen(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    checkpendingLeaveStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3cee5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 50,
              ),
              //container to show student name
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xfff0f8ff),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff8d8989),
                          spreadRadius: 1,
                          blurRadius: 15)
                    ],
                  ),
                  height: 100,
                  child: Center(
                    child: Column(children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Welcome ",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f8ff),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xff8d8989),
                              spreadRadius: 1,
                              blurRadius: 15)
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              cdate,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Mark Your Attndance",
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          !markedAttandance
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: GestureDetector(
                                            onTap: () {
                                              updateabsentnumber();
                                              createattandancerecordabsent();
                                              updateLeaveinMain();
                                              attandacemarked();
                                            },
                                            child: const attandancecontainer(
                                              color: Colors.red,
                                              text: "Absent",
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            updatepresentnumber();
                                            createattandancerecord();
                                            checkMarkedOn();
                                            updateLeaveinMain();
                                            attandacemarked();
                                          },
                                          child: const attandancecontainer(
                                            color: Colors.green,
                                            text: "Present",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        leave_approved
                                            ? GestureDetector(
                                                onTap: () {
                                                  updateLeaveStatus();
                                                  checkLeaveStatus();
                                                  createattandancerecordleave();
                                                  updateLeaveinMain();
                                                  attandacemarked();
                                                },
                                                child: markLeaveButton(),
                                              )
                                            : GestureDetector(
                                                onTap: leaveReq,
                                                child: Reqleavebutton(),
                                              )
                                      ],
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Today's Attandace has been Marked",
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                        onTap: signOut,
                        child: loginsignupbutton(hinttext: "Logout"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class markLeaveButton extends StatelessWidget {
  const markLeaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.lightBlue, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          "Mark Leave",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Reqleavebutton extends StatelessWidget {
  const Reqleavebutton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "Req Leave",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}

class attandancecontainer extends StatelessWidget {
  final color;
  final text;
  const attandancecontainer(
      {super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
