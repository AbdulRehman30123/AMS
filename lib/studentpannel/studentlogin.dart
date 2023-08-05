import 'package:ams/studentpannel/studentscreens/studentfirstscreen.dart';
import 'package:ams/studentpannel/studentsignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../adminpannel/adminfunctions.dart';

class studentlogin extends StatefulWidget {
  const studentlogin({Key? key}) : super(key: key);

  @override
  State<studentlogin> createState() => _studentloginState();
}

class _studentloginState extends State<studentlogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //this is for login
  void loginuser() async {
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
          builder: (context) => StudentFirstScreen(),
        ),
      );
      showLoggedinMessaage();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
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
      backgroundColor: Color(0xffb3cee5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (const SizedBox(
                height: 60,
              )),
              Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset('assets/login.svg'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              //for getting user email
              textfield(
                controller: _emailController,
                hinttext: "Email",
              ),
              const SizedBox(
                height: 20.0,
              ),
              //for getting user password
              textfield(controller: _passwordController, hinttext: "Password"),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () => loginuser(),
                child: loginsignupbutton(
                  hinttext: "Login",
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              signupline(
                text1: "Don't have an Account  ",
                text2: "Signup Now",
              )
            ],
          ),
        ),
      ),
    );
  }
}

class signupline extends StatelessWidget {
  final String text1, text2;
  const signupline({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: text1,
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
                    MaterialPageRoute(builder: (context) => studentsignup()),
                  );
                },
              text: text2,
              style: TextStyle(
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

class loginsignupbutton extends StatefulWidget {
  final String hinttext;
  const loginsignupbutton({super.key, required this.hinttext});

  @override
  State<loginsignupbutton> createState() => _loginsignupbuttonState();
}

class _loginsignupbuttonState extends State<loginsignupbutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 150,
      decoration: BoxDecoration(
          color: Color(0xfff0f8ff),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 5  horizontally
                5.0, // Move to bottom 5 Vertically
              ),
            )
          ]),
      child: Text(
        widget.hinttext,
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class textfield extends StatefulWidget {
  const textfield(
      {super.key, required this.controller, required this.hinttext});
  final TextEditingController controller;
  final String hinttext;

  @override
  State<textfield> createState() => _textfieldState();
}

class _textfieldState extends State<textfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        controller: widget.controller,
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
          hintText: widget.hinttext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
