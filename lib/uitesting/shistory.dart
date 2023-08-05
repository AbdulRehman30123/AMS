import 'package:flutter/material.dart';

class shistory extends StatefulWidget {
  const shistory({Key? key}) : super(key: key);

  @override
  State<shistory> createState() => _shistoryState();
}

class _shistoryState extends State<shistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("history"),
      ),
    );
  }
}
