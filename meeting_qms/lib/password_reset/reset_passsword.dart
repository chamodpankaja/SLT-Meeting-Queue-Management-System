import 'package:flutter/material.dart';
import 'package:meeting_qms/widgets/TextFields/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';


class ResetPasssword extends StatefulWidget {
  const ResetPasssword({super.key});

  @override
  State<ResetPasssword> createState() => _ResetPassswordState();
}

class _ResetPassswordState extends State<ResetPasssword> {

  final _formKey = GlobalKey<FormState>(); // key for  form validation
  final TextEditingController _emailController = TextEditingController();


  Future<void> _Reset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {

        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        
       PopupSnackBar.showSuccessMessage(context, 'Password Reset Email Sent');
        _emailController.clear();
        await Future.delayed(const Duration(milliseconds: 1000));

        Navigator.pushReplacementNamed(context, '/signin');
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, 
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // Header Text
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Password Reset ?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color:  Color(0xFF1A5EBF),
                    ),
                  ),
                ),
              ),

              //const SizedBox(height: 40),
              const Image(image: AssetImage('assets/slt_logo/sltLogo.png'),
                width: 200,
                height: 200,
              ),

              Align(
                alignment: Alignment.topLeft, // align to the top left corner
                child: Padding(
                  padding: EdgeInsets.all(20), // add padding around the text
                  child: Text(
                    "Enter your Email and we will send you a link to reset your password.",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: buildTextField("Email", _emailController, _validateEmail)
              ),

              const SizedBox(height: 40),

              

              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1A5EBF)), // Change color
                    )
                  :

                  // email send Button
                  Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF1A5EBF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _Reset();
                        },
                        child: const Text(
                          'Send Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
