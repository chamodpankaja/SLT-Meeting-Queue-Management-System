import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child : Text(
          'welcome user: ${FirebaseAuth.instance.currentUser?.email ?? "Guest"}',
          style: const TextStyle(
            color: Colors.black
          ),
        ),
      )
      ,
    );
  }
}