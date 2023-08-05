import 'package:ams/studentpannel/studentscreens/studenthome.dart';
import 'package:ams/studentpannel/studentscreens/studentprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class StudentFirstScreen extends StatefulWidget {
  const StudentFirstScreen({Key? key}) : super(key: key);

  @override
  State<StudentFirstScreen> createState() => _StudentFirstScreenState();
}

class _StudentFirstScreenState extends State<StudentFirstScreen> {
  List screens = [studenthome(), StudentProfile()];
  int _selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedindex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: GNav(
          backgroundColor: Color(0xfff0f8ff),
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor: Color(0xffb3cee5),
          gap: 10,
          padding: EdgeInsets.all(10),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          tabs: const [
            GButton(
              icon: Icons.account_circle,
              text: 'Profile',
            ),
            GButton(
              icon: Icons.home,
              text: 'Dashboard',
            ),
          ],
          selectedIndex: _selectedindex,
          onTabChange: (index) {
            setState(() {
              _selectedindex = index;
            });
          },
        ),
      ),
    );
  }
}
