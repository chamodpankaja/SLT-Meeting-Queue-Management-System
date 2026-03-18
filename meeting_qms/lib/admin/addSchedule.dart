import 'package:flutter/material.dart';
import 'package:meeting_qms/admin/admin_main_screen.dart';
import 'package:intl/intl.dart';
import 'package:meeting_qms/service/notification_service.dart';
import 'package:meeting_qms/widgets/TextFields/textField.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Addschedule extends StatefulWidget {
  const Addschedule({super.key});

  @override
  State<Addschedule> createState() => _AddscheduleState();
}

class _AddscheduleState extends State<Addschedule> {
  final _formKey = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  final _venueController = TextEditingController();

  final List<String> _techStacks = [
    'Flutter',
    'React',
    'Node.js',
    'Python',
    'Java',
    'JavaScript',
    'C#',
    'PHP',
    'Ruby',
    'Swift',
    'Kotlin',
    'Dart'
  ];
  List<String> _selectedTechStacks = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final FocusNode _sessionNameFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _timeFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();
  final FocusNode _venueFocus = FocusNode();

  @override
  void dispose() {
    _sessionNameController.dispose();
    _dateController.dispose();
    _venueController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    _sessionNameFocus.dispose();
    _dateFocus.dispose();
    _timeFocus.dispose();
    _venueFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A5EBF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A5EBF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      FocusScope.of(context).requestFocus(_timeFocus);
    }
  }

  // Future<void> _selectTime(BuildContext context) async {
  //   // final TimeOfDay? picked = await showTimePicker(
  //   //   context: context,
  //   //   initialTime: TimeOfDay.now(),
  //   // );
  //   final TimeOfDay? picked = await showTimePicker(
  //   context: context,
  //   initialTime: TimeOfDay.now(),
  //   builder: (BuildContext context, Widget? child) {
  //     return Theme(
  //       data: Theme.of(context).copyWith(
  //         timePickerTheme: TimePickerThemeData(
  //           backgroundColor: Colors.white, // Change this to your desired color
  //           hourMinuteColor: Colors.white,
  //           hourMinuteTextColor: Colors.black,
  //           dialBackgroundColor: Colors.white,
  //           dayPeriodColor: Colors.white,
  //           dayPeriodTextColor: Colors.black,
  //         ),
  //       ),
  //       child: child!,
  //     );
  //   },
  // );
  //   if (picked != null && picked != _selectedTime) {
  //     setState(() {
  //       _selectedTime = picked;
  //       _timeController.text = picked.format(context);
  //     });
  //     FocusScope.of(context).unfocus();
  //   }
  // }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: const Color(0xFF1A5EBF).withOpacity(0.1),
              hourMinuteTextColor: const Color(0xFF1A5EBF),
              dialHandColor: const Color(0xFF1A5EBF),
              dialBackgroundColor: Colors.white,
              dialTextColor: Colors.black87,
              entryModeIconColor: const Color(0xFF1A5EBF),
              dayPeriodColor: const Color(0xFF1A5EBF).withOpacity(0.1),
              dayPeriodTextColor: const Color(0xFF1A5EBF),
              helpTextStyle: const TextStyle(
                color: Color(0xFF1A5EBF),
                fontSize: 12,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A5EBF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _submitForm() async {
    try {
      if (_formKey.currentState!.validate() && _selectedTechStacks.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          PopupSnackBar.showUnsuccessMessage(context, 'User not authenticated');
          return;
        }

        // Get user data
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Prepare schedule data
        final scheduleData = {
          'userId': user.uid,
          'sessionName': _sessionNameController.text.trim(),
          'date': _dateController.text,
          'time': _timeController.text,
          'venue': _venueController.text.trim(),
          'notes': _notesController.text.trim(),
          'techStacks': _selectedTechStacks,
          'createdBy':
              "Mr. ${snapshot.data()?['name'].split(' ')[0] ?? 'User'}",
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Add to Firestore
        await FirebaseFirestore.instance
            .collection('schedules')
            .add(scheduleData);

        await NotificationService.instance.showNotification(
          title: 'New Schedule Added',
          body:
              'Session: ${_sessionNameController.text.trim()} on ${_dateController.text} at ${_timeController.text}',
        );

        // Clear form
        _clearForm();

        // Show success message
        if (mounted) {
          PopupSnackBar.showSuccessMessage(
              context, 'Schedule added successfully');
          // Navigate back to admin home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminMainScreen()),
          );
        }
      } else if (_selectedTechStacks.isEmpty) {
        PopupSnackBar.showUnsuccessMessage(
            context, 'Please select at least one tech stack');
      }
    } catch (e) {
      PopupSnackBar.showUnsuccessMessage(
          context, 'Failed to add schedule. Please try again.');
      print('Error adding schedule: $e');
    }
  }

// Helper method to clear form
  void _clearForm() {
    _sessionNameController.clear();
    _dateController.clear();
    _timeController.clear();
    _venueController.clear();
    _notesController.clear();
    setState(() {
      _selectedTechStacks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xff1A5EBF), size: 30.0),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminMainScreen()),
            );
          },
        ),
        title: const Text(
          "Add Schedule",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1A5EBF),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  'Session Name',
                  _sessionNameController,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter session name';
                    }
                    return null;
                  },
                )!,
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  focusNode: _dateFocus,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    hintText: 'Date',
                    suffixIcon: const Icon(Icons.calendar_today,
                        color: Color(0xFF1A5EBF)),
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF1A5EBF), width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Color(0xFF1A5EBF)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  focusNode: _timeFocus,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    hintText: 'Start Time',
                    suffixIcon:
                        const Icon(Icons.access_time, color: Color(0xFF1A5EBF)),
                    hintStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF1A5EBF), width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select time';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Color(0xFF1A5EBF)),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  'Venue',
                  _venueController,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter venue name';
                    }
                    return null;
                  },
                )!,
                const SizedBox(height: 16),
                const Text(
                  'Tech Stacks',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0, // Add vertical spacing between rows
                  children: _techStacks.map((String tech) {
                    return FilterChip(
                      backgroundColor: Colors.blue.shade50,
                      selectedColor: const Color(0xFF1A5EBF).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF1A5EBF),
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      padding: const EdgeInsets.all(4.0),
                      showCheckmark: true,
                      label: Text(
                        tech,
                        style: TextStyle(
                          color: _selectedTechStacks.contains(tech)
                              ? const Color(0xFF1A5EBF)
                              : Colors.black87,
                          fontWeight: _selectedTechStacks.contains(tech)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      selected: _selectedTechStacks.contains(tech),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedTechStacks.add(tech);
                          } else {
                            _selectedTechStacks.remove(tech);
                          }
                        });
                      },
                      elevation: 0,
                      pressElevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: _selectedTechStacks.contains(tech)
                              ? const Color(0xFF1A5EBF)
                              : Colors.black87.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  'Special Notes (Optional)',
                  _notesController,
                  null,
                )!,
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff1A5EBF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // _signup();
                        _submitForm();
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
