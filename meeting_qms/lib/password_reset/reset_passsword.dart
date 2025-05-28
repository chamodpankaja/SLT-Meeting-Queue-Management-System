import 'package:flutter/material.dart';

class ResetPasssword extends StatefulWidget {
  const ResetPasssword({super.key});

  @override
  State<ResetPasssword> createState() => _ResetPassswordState();
}

class _ResetPassswordState extends State<ResetPasssword> {

  final _formKey = GlobalKey<FormState>(); // key for  form validation
  final TextEditingController _emailController = TextEditingController();

  
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
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    filled: true,
                    fillColor:
                        Colors.white12, // Keeps the semi-transparent background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.black87, width: 1.5), // Default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 1.5), // Unfocused border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color:  Color(0xFF1A5EBF),
                          width: 2.0), // Focused border color
                    ),
                  ),
                  style: const TextStyle(
                      color:Color(0xFF1A5EBF)), // Text color when typing
                  cursorColor: Color(0xFF1A5EBF), // Cursor color when typing
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

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
                          //_Reset();
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
}
