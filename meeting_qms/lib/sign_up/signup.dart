import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_qms/widgets/TextFields/passwordField.dart';
import 'package:meeting_qms/widgets/TextFields/textField.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save user information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'uid': userCredential.user?.uid,
          'name': _nameController.text,
          'email': _emailController.text,
          'createdAt': Timestamp.now(), // Store creation date
          'role': 'user', // Default role, modify as needed
        });

        PopupSnackBar.showSuccessMessage(context, 'Signup successful');

        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // Navigate to the next screen after successful signup
        Navigator.pushReplacementNamed(
            context, '/home'); // Change this to your desired route
      } on FirebaseAuthException catch (e) {
        // Handle errors
        PopupSnackBar.showUnsuccessMessage(
            context, e.message ?? 'Signup failed');
        //
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
              //const SizedBox(height: 50),

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
                  "Register",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4FB846)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // name input

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildTextField(
                      "your name", _nameController, _validateName)),

              const SizedBox(height: 20),

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
                  "Create a Password",
                  _passwordController,
                  _validatePassword,
                  _isPasswordHidden,
                  (bool newValue) {
                    setState(() {
                      _isPasswordHidden = newValue;
                    });
                  },
                ),
              ),

              //password confirm
              const SizedBox(height: 20),

              // Password Input Field
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildPasswordField(
                    "Confirm Password",
                    _confirmPasswordController,
                    _validateConfirmPassword,
                    _isPasswordHidden,
                    (bool newValue) {
                      setState(() {
                        _isPasswordHidden = newValue;
                      });
                    },
                  )),

              const SizedBox(height: 30),

              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff1A5EBF)), // Change color
                    )
                  :

                  // Continue Button
                  Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xff1A5EBF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _signup();
                        },
                        child: const Text(
                          'Sign up',
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
                  text: "Already have an account? ",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: const TextStyle(
                        color: Color(0xff1A5EBF),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signin');
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

  //validating funtions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
