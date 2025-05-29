import 'package:flutter/material.dart';

class PopupSnackBar {
  static void showSnackBar(BuildContext context, String message, Color color) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          duration: const Duration(seconds: 4),
          content: SizedBox(
            width: 200, // Adjust the width to your desired value
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          behavior: SnackBarBehavior.floating, // Makes the SnackBar smaller
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print('error eccoured ${e.toString()}');
    }
  }

  static void showSuccessMessage(BuildContext context, String message) {
    showSnackBar(context, message, Colors.green);
  }

  static void showUnsuccessMessage(BuildContext context, String message) {
    showSnackBar(context, message, Colors.red);
  }
}
