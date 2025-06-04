import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:meeting_qms/admin/adminHome.dart';
import 'package:meeting_qms/widgets/TextFields/passwordField.dart';
import 'package:meeting_qms/widgets/TextFields/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>(); // key for  form validation
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        final user = userCredential.user;

        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          final userData = userDoc.data() as Map<String, dynamic>;
          final role = userData['role'];

          PopupSnackBar.showSuccessMessage(context, 'Login successful');
          _emailController.clear();
          _passwordController.clear();

          if (role == 'admin') {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Adminhome()));
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        PopupSnackBar.showUnsuccessMessage(
            context, 'Login failed: email or password is incorrect');
        print('Login error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Background color), // Dark green background
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Top Logo
              ClipRRect(
                child: Image.asset(
                  'assets/slt_logo/sltLogo.png',
                  width: 200,
                  height: 200,
                ),
              ),

              const Text(
                'SLT Meeting QMS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1A5EBF),
                  letterSpacing: 1.5,
                ),
              ),

              // Header Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4FB846),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Email Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: buildTextField(
                  "Email",
                  _emailController,
                  _validateEmail,
                ),
              ),

              const SizedBox(height: 20),

              // Password Input Field
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildPasswordField(
                    "Password",
                    _passwordController,
                    _validatePassword,
                    _isPasswordHidden,
                    (bool newValue) {
                      setState(() {
                        _isPasswordHidden = newValue;
                      });
                    },
                  )),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF1A5EBF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1A5EBF)), // Change color
                    )
                  :

                  // Continue Button
                  Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1A5EBF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _signIn();
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 40),

              // Bottom Sign-up Text
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: const TextStyle(
                        color: Color(0xFF1A5EBF),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }
}
