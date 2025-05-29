import 'package:flutter/material.dart';

Widget? buildTextField(
  String label,
  TextEditingController controller,
  String? Function(String?)? validator,
) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
      ),
      // Add error style for error text
      errorStyle: const TextStyle(
        color: Colors.red, // Change error text color
        fontSize: 14,
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
      // Add error border styling
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Colors.red, // Change error border color
            width: 1.5),
      ),
      // Add focused error border styling
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Colors.red, // Change focused error border color
            width: 2.0),
      ),
    ),
    style: const TextStyle(color: Color(0xFF1A5EBF)),
    cursorColor: const Color(0xFF1A5EBF),
  );
}
