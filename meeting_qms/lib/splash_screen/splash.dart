import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_qms/admin/adminHome.dart';
import 'package:meeting_qms/user/home.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = doc.data();

        if (data != null && data.containsKey('role')) {
          final role = data['role'];

          if (!mounted) return;

          if (role == 'admin') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Adminhome()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
        } else {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      } catch (e) {
        PopupSnackBar.showUnsuccessMessage(context, "Error fetching user role");
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/signin');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/slt_logo/sltLogo.png',
                    width: 250,
                    height: 250,
                  ),

                  // const SizedBox(height: 10),
                  // const Text(
                  //   'Welcome to',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     color: Color(0xff1A5EBF),
                  //     letterSpacing: 1.2,
                  //   ),
                  // ),
                  //const SizedBox(height: 10),
                  // const Text(
                  //   'SLT Meeting QMS',
                  //   style: TextStyle(
                  //     fontSize: 32,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xff1A5EBF),
                  //     letterSpacing: 1.5,
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // const CircularProgressIndicator(
                  //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1A5EBF)),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
