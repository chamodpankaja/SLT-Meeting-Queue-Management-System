import 'package:flutter/material.dart';
import 'package:meeting_qms/admin/addSchedule.dart';
import 'package:meeting_qms/admin/adminHome.dart';
import 'package:meeting_qms/admin/admin_nav_bar.dart';

class AdminMainScreen extends StatefulWidget {
  final int selectedIndex;
  AdminMainScreen({this.selectedIndex = 0});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late int _currentIndex;
   @override
   void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  final List<Widget> _pages = [
   Adminhome(),
    Addschedule(),
     Adminhome(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
