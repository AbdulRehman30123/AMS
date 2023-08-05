import 'package:ams/studentpannel/attandancemodel.dart';
import 'package:ams/studentpannel/studentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class studentui extends StatefulWidget {
  const studentui({Key? key}) : super(key: key);

  @override
  State<studentui> createState() => _studentuiState();
}

class _studentuiState extends State<studentui> {
  List<Studentmodel> studentrecord = [];
  List attandancerecord = [];
  late Map<String, dynamic> studentname;
  final user = FirebaseAuth.instance.currentUser!;
  var numberOfLeaves;
  bool leavestatus = false;
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
    print(studentrecord);
  }

  void leaveStatus() {
    if (numberOfLeaves != 0) {
      setState(() {
        leavestatus = true;
      });
    }
  }

  void checkLeaveReq() async {
    final adminID = await FirebaseAuth.instance.currentUser!.uid;
    var records =
        await FirebaseFirestore.instance.collection("Admin").doc(adminID).get();
    Map<String, dynamic>? doc = records.data();
    var _numberofleaves = doc!['Number of Leave Requests'];
    var _leavestatus = doc['leave status'];
    setState(() {
      numberOfLeaves = _numberofleaves;
      print(numberOfLeaves);
      print(_leavestatus);
    });
    leaveStatus();
  }

  void deleteAttandanceRecord() async {
    final record =
        await FirebaseFirestore.instance.collection("Students").get();
    Iterable<QuerySnapshot<Map<String, dynamic>>> doc = record.docs
        .map(
          (item) => Attandancerecord(
            id: item.id,
            attandanceStatus: item["Email"],
          ),
        )
        .cast<QuerySnapshot<Map<String, dynamic>>>()
        .toList();
    setState(
      () {
        attandancerecord = record as List<Attandancerecord>;
      },
    );
  }

  void delete() async {
    final _r = await FirebaseFirestore.instance
        .collection("Students")
        .doc("")
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    //fetchRecords();
    checkLeaveReq();
    //leaveStatus();
    super.initState();
  }

  //ths method will grab aa specific collection/data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User id: " + user.uid),
      ),
      // body: ListView.builder(
      //   itemCount: 3,
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: EdgeInsets.all(10),
      //       child: Container(
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(
      //               20,
      //             ),
      //             color: Colors.lightBlue),
      //         child: ListTile(
      //           title: Text(
      //             studentrecord[index].studentName,
      //             style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontStyle: FontStyle.italic,
      //                 fontSize: 20,
      //                 color: Colors.white),
      //           ),
      //           subtitle: Padding(
      //             padding: EdgeInsets.symmetric(vertical: 5),
      //             child: Text(
      //               studentrecord[index].Email,
      //               style: const TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                   fontStyle: FontStyle.italic,
      //                   fontSize: 15,
      //                   color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              checkLeaveReq();
            },
            child: Text("check leaves"),
          ),
          leavestatus
              ? Text("you have${numberOfLeaves}")
              : Text("you have no leaves"),
          ElevatedButton(
            onPressed: deleteAttandanceRecord,
            child: Text("attandance record"),
          ),
          ElevatedButton(
            onPressed: delete,
            child: Text("delete "),
          )
        ],
      ),
    );
  }
}
