import 'package:flutter/material.dart';

class AdminNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  AdminNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue.shade50,
      selectedItemColor: Color(0xff1A5EBF),
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 0 ? Icons.home : Icons.home_outlined,
            size: 30,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 1 ? Icons.schedule : Icons.schedule_outlined,
            size: 30,
          ),
          label: "Schedule Meeting",
        ),
       BottomNavigationBarItem(
  icon: Image(
    image: AssetImage(
      currentIndex == 2
          ? "assets/queue.png"
          : "assets/queue.png",
    ),
    width: 40,
    height: 40,
     color: currentIndex == 2 ?  Color(0xff1A5EBF) : Colors.black,
  ),
  label: "Manage Meetings",
), 
      ],
    );
  }
}
