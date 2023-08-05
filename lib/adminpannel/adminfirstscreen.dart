import 'package:ams/adminpannel/admindashboard.dart';
import 'package:ams/adminpannel/adminprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminFirstScreen extends StatefulWidget {
  const AdminFirstScreen({Key? key}) : super(key: key);

  @override
  State<AdminFirstScreen> createState() => _AdminFirstScreenState();
}

class _AdminFirstScreenState extends State<AdminFirstScreen> {
  List screens = [AdminProfile(), AdminDashboard()];
  int _selectedindex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedindex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          backgroundColor: Color(0xfff0f8ff),
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor: Color(0xffb3cee5),
          gap: 10,
          padding: EdgeInsets.all(16),
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
