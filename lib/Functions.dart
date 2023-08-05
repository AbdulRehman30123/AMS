import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
String tdate = DateFormat("HH:mm:ss").format(DateTime.now());
final userid = FirebaseAuth.instance.currentUser!.uid;
String userName = "";
String leaveStatus = "";
int presents = 0;
int absents = 0;
int leaves = 0;

// create subcollection in main colection
void createattandancerecord() async {
  final _uid = await FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Students")
      .doc(_uid)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .set({"attandance status": "null"}).then(
          (value) => updateattandanceRecordpresent());
}

void createattandancerecordabsent() async {
  final _uid = await FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Students")
      .doc(_uid)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .set({"attandance status": "null", "marked on": "null"}).then(
          (value) => updateattandanceRecordabsent());
}

void createattandancerecordleave() async {
  final _uid = await FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection("Students")
      .doc(_uid)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .set({"attandance status": "null", "marked on": "null"}).then(
          (value) => updateattandanceRecordabsent());
}

//updating name in main collection data in firestore
void updatenaeme() async {
  final _user = FirebaseAuth.instance.currentUser!.uid;
  final user = FirebaseFirestore.instance.collection("Students").doc(_user);
  user.update({"student name": "ark"});
}

// mark present in subcollection
void updateattandanceRecordpresent() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecords = FirebaseFirestore.instance
      .collection("Students")
      .doc(_user)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .update(
    {
      "attandance status": "Present",
      "marked on": DateFormat("yyyy-MM-dd").format(DateTime.now())
    },
  );
  updateMarkedOn();
}

// mark absent in subcollection
void updateattandanceRecordabsent() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecords = FirebaseFirestore.instance
      .collection("Students")
      .doc(_user)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .update(
    {
      "attandance status": "Absent",
      "marked on": DateFormat("yyyy-MM-dd").format(DateTime.now())
    },
  );
  updateMarkedOn();
}

void updateattandanceRecordleave() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecords = FirebaseFirestore.instance
      .collection("Students")
      .doc(_user)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      )
      .update(
    {
      "attandance status": "Leave",
      "marked on": DateFormat("yyyy-MM-dd").format(DateTime.now())
    },
  );
  updateMarkedOn();
}

// update leave status in subcollection
void updateLeaveStatus() async {
  final _leaveStatus = await FirebaseFirestore.instance
      .collection("Students")
      .doc(userid)
      .collection("attandancerecord")
      .doc(
        DateFormat("yyyy-MM-dd").format(
          DateTime.now(),
        ),
      );
  _leaveStatus.update(
    {
      "attandance status": "Leave",
      "marked on": DateFormat("yyyy-MM-dd").format(DateTime.now())
    },
  );
  updateleavenumber();
  updateMarkedOn();
}

//update leavestatus in main collection
void updateLeaveinMain() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final _leavestatus =
      await FirebaseFirestore.instance.collection("Students").doc(_user);

  _leavestatus.update({"leave status": "null"});
}

// when user tab present button in ocntainer it will increase number of presents in main collection and then mark present in attandance record collection
void updatepresentnumber() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecord =
      await FirebaseFirestore.instance.collection("Students").doc(_user);

  attandancerecord.update({"number of presents": FieldValue.increment(1)});
}

// update absent numbers in main collection of user
void updateabsentnumber() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecord =
      await FirebaseFirestore.instance.collection("Students").doc(_user);

  attandancerecord.update({"number of absents": FieldValue.increment(1)});
}

// update leave numbers in main collection of user
void updateleavenumber() async {
  final _user = await FirebaseAuth.instance.currentUser!.uid;
  final attandancerecord =
      await FirebaseFirestore.instance.collection("Students").doc(_user);

  attandancerecord.update({"number of leaves": FieldValue.increment(1)});
}

void leaveReq() async {
  final _leaveStatus =
      await FirebaseFirestore.instance.collection("Students").doc(userid);
  _leaveStatus.update(
    {"leave status": "pending"},
  ).whenComplete(
    () => updateLeavenumberinAdmin(),
  );
}

void updateMarkedOn() async {
  final _markedOn =
      await FirebaseFirestore.instance.collection("Students").doc(userid);
  _markedOn.update(
    {
      "marked on": DateFormat("yyyy-MM-dd").format(
        DateTime.now(),
      ),
    },
  );
}

void updateLeavenumberinAdmin() async {
  final _number = await FirebaseFirestore.instance
      .collection("Admin")
      .doc("qUUm8FbqadSsXy1XzLTYMeT1zXI3");
  _number.update(
    {"Number of Leave Requests": FieldValue.increment(1)},
  );
}

void updateLeavenumberbyAdmin() async {
  final _number = await FirebaseFirestore.instance
      .collection("Admin")
      .doc("qUUm8FbqadSsXy1XzLTYMeT1zXI3");
  _number.update(
    {
      "Number of Leave Requests": FieldValue.increment(-1),
    },
  );
}
