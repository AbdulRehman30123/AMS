import 'package:ams/Functions.dart';
import 'package:ams/colors.dart';
import 'package:ams/studentpannel/studentmodel.dart';
import 'package:ams/studentpannel/studentscreens/studentprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'adminfunctions.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({required this.studentmodel});
  final Studentmodel studentmodel;

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  String imageURL = "";
  bool imageURLSet = false;
  var deleteDate;
  final date = TextEditingController();
  void approveLeave() async {
    final _leaveStatus = await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.studentmodel.id);
    _leaveStatus.update(
      {"leave status": "Approve"},
    ).whenComplete(() => showAcceptedLeaveMessage());
    updateLeavenumberbyAdmin();
  }

  void rejectLeave() async {
    final _leaveStatus = await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.studentmodel.id);
    _leaveStatus.update(
      {"leave status": "Rejected"},
    ).whenComplete(() => showRejectedLeaveMessage());
    updateLeavenumberbyAdmin();
  }

  void checkNumberofPResents() async {
    final pnumbers = await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.studentmodel.id);
  }

  showAcceptedLeaveMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Leave Approved",
          color: Colors.green,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  showRejectedLeaveMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Leave Rejected",
          color: Colors.redAccent,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void imageurl() async {
    String downloadURL = await FirebaseStorage.instance
        .ref()
        .child("studentpics")
        .child(widget.studentmodel.id)
        .child("profilepics")
        .getDownloadURL();
    print(downloadURL);
    setState(() {
      imageURL = downloadURL;
      imageURLSet = true;
    });
  }

  void updateImageUrl() async {
    final _imageurl = await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.studentmodel.id);
    _imageurl.update({"image url": imageURL});
  }

  void showdeletedate() {
    setdate();
    print(deleteDate.toString());
  }

  void setdate() {
    setState(() {
      deleteDate = date.toString();
    });
  }

  void deleteAttandanceRecord() async {
    final _r = await FirebaseFirestore.instance
        .collection("Students")
        .doc(widget.studentmodel.id)
        .collection("attandacerecord")
        .doc(
          deleteDate.toString().trim(),
        )
        .delete()
        .whenComplete(
          () => showDeletedMessaage(),
        );
  }

  showDeletedMessaage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Deleted",
          color: Colors.red,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    imageurl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              imageURLSet
                  ? Container(
                      height: 150,
                      width: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.network(imageURL),
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(),
                    ),
              detailcontainer(text: widget.studentmodel.studentName),
              detailcontainer(text: widget.studentmodel.Email),
              detailcontainer(
                  text: "No of Leaves: ${widget.studentmodel.numberofleaves}"),
              detailcontainer(
                  text:
                      "No of Presents: ${widget.studentmodel.numberofpresents}"),
              detailcontainer(
                  text:
                      "No of Absents: ${widget.studentmodel.numberofabsents}"),
              detailcontainer(
                  text: "Leave Status: ${widget.studentmodel.leavestatus}"),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      approveLeave();
                    },
                    child: LeaveButton(
                      color: Colors.green.shade100,
                      text: "Approve",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      rejectLeave();
                    },
                    child:
                        LeaveButton(color: Colors.red.shade400, text: "Reject"),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: date,
                  decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Color(0xff005A9C),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Color(0xfff0f8ff),
                      ),
                    ),
                    fillColor: const Color(0xfff0f8ff),
                    hintText: "YY-MM-DD",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        deleteAttandanceRecord();
                      },
                      child: LeaveButton(color: Colors.red, text: "Delete"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveButton extends StatelessWidget {
  final Color color;
  final String text;
  const LeaveButton({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
