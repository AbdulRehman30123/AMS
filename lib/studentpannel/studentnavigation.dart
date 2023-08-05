import 'package:ams/studentpannel/studentscreens/studenthome.dart';
import 'package:ams/studentpannel/studentscreens/studentprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SNavigaton extends StatefulWidget {
  const SNavigaton({Key? key}) : super(key: key);

  @override
  State<SNavigaton> createState() => _SNavigatonState();
}

class _SNavigatonState extends State<SNavigaton> {
  List _screens = [
    studenthome(),
    StudentProfile(),
  ];
  int _selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.account_circle,
            text: "Home",
          )
        ],
        selectedIndex: _selectedindex,
        onTabChange: (index) {
          _selectedindex = index;
        },
      ),
    );
  }
}
