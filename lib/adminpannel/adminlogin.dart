import 'package:ams/adminpannel/adminfirstscreen.dart';
import 'package:ams/adminpannel/adminsignup.dart';
import 'package:ams/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../studentpannel/studentlogin.dart';
import 'adminfunctions.dart';

class adminlogin extends StatefulWidget {
  const adminlogin({Key? key}) : super(key: key);

  @override
  State<adminlogin> createState() => _adminloginState();
}

class _adminloginState extends State<adminlogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void loginAdmin() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminFirstScreen(),
        ),
      );
      showLoggedinMessaage();
      //showLoggedinMessaage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  showLoggedinMessaage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: customflashmessage(
          messagetext: "Logged In",
          color: Colors.green,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email "),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Password "),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset("assets/login.svg"),
              ),
              const SizedBox(
                height: 20.0,
              ),
              textfield(controller: _emailController, hinttext: "Email"),
              const SizedBox(
                height: 20.0,
              ),
              textfield(controller: _passwordController, hinttext: "Password"),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  loginAdmin();
                },
                child: loginsignupbutton(hinttext: "Login"),
              ),
              const SizedBox(
                height: 50,
              ),
              const signupline()
            ],
          ),
        ),
      ),
    );
  }
}

class signupline extends StatelessWidget {
  const signupline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "Don't have Account?   ",
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminSignup()),
                  );
                },
              text: "Signup Now",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff6495ED),
              ),
            )
          ]),
    );
  }
}
