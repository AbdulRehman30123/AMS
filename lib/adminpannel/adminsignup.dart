import 'package:ams/adminpannel/adminlogin.dart';
import 'package:ams/colors.dart';
import 'package:ams/studentpannel/studentlogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'adminfunctions.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({Key? key}) : super(key: key);

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _name = TextEditingController();
  //admin will create from this function
  void _createAdmin() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
          .then(
            (value) => _storeAdminData(),
          );
      showSignedUpMessaage();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => adminlogin()),
    );
  }

  // this fucntion will store admin data in admin colection and we will call this function in above fucntion
  void _storeAdminData() async {
    final _userid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("Admin").doc(_userid).set(
      {
        "Email": _emailController.text.trim(),
        "Name": _name.text.trim(),
        "Password": _passwordController.text.trim(),
        "Number of Leave Requests": 0
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 150,
              width: 200,
              child: SvgPicture.asset("assets/welcome.svg"),
            ),
            const SizedBox(
              height: 10,
            ),
            textfield(controller: _emailController, hinttext: "Email"),
            const SizedBox(
              height: 10,
            ),
            textfield(controller: _passwordController, hinttext: "Password"),
            const SizedBox(
              height: 10,
            ),
            textfield(controller: _name, hinttext: "Name"),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  _createAdmin();
                },
                child: loginsignupbutton(
                  hinttext: "Signup",
                )),
          ],
        ),
      ),
    );
  }
}
