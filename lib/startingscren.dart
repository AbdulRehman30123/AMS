import 'package:ams/adminpannel/adminlogin.dart';
import 'package:ams/colors.dart';
import 'package:ams/studentpannel/studentlogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class startingscreen extends StatefulWidget {
  const startingscreen({Key? key}) : super(key: key);

  @override
  State<startingscreen> createState() => _startingscreenState();
}

class _startingscreenState extends State<startingscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldColor,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const studentlogin()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: SvgPicture.asset("assets/student.svg"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Login as Student",
                  style: GoogleFonts.ptSerif(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const adminlogin()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: SvgPicture.asset("assets/teacher.svg"),
                    ),
                  ),
                ),
                 Text(
                  "Login as Admin",
                  style: GoogleFonts.ptSerif(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
