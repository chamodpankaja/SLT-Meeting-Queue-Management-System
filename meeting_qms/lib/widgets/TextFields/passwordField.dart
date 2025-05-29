import 'package:flutter/material.dart';

Widget buildPasswordField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
    bool isHidden,
    Function(bool) onPasswordVisibilityChanged) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: isHidden,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      filled: true,
      fillColor: Colors.white12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black87, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A5EBF), width: 2.0),
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isHidden ? Icons.visibility_off : Icons.visibility,
          color: const Color(0xFF1A5EBF),
        ),
        onPressed: () => onPasswordVisibilityChanged(!isHidden),
      ),
    ),
    style: const TextStyle(color: Color(0xFF1A5EBF)),
    cursorColor: const Color(0xFF1A5EBF),
  );
}