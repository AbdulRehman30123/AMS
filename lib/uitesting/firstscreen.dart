import 'package:ams/uitesting/shome.dart';
import 'package:ams/uitesting/sprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'shistory.dart';

class firstscreen extends StatefulWidget {
  const firstscreen({Key? key}) : super(key: key);

  @override
  State<firstscreen> createState() => _firstscreenState();
}

class _firstscreenState extends State<firstscreen> {
  List screens = [
    shome(),
    sprofile(),
    shistory(),
  ];
  int _selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedindex],
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Likes',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
        ],
        selectedIndex: _selectedindex,
        onTabChange: (index) {
          setState(() {
            _selectedindex = index;
          });
        },
      ),
    );
  }
}
