import 'package:flutter/material.dart';
import 'package:meeting_qms/user/home.dart';
import 'package:meeting_qms/password_reset/reset_passsword.dart';
import 'package:meeting_qms/sign_in/sign_in.dart';
import 'package:meeting_qms/sign_up/signup.dart';
import 'package:meeting_qms/splash_screen/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Movie Finder',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          "/signup": (context) => const SignUpScreen(),
          "/signin": (context) => const SignIn(),
          "/reset": (context) => const ResetPasssword(),
          "/home": (context) => const Home()
        });
  }
}
