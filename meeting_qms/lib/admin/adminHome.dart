import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_qms/widgets/SessionCard.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';
import 'package:meeting_qms/widgets/side_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "UserName";
  bool _isLoading = true;
  List<DocumentSnapshot> _sessions = [];

  final List<String> _localImages = [
    "assets/image1.png",
    "assets/image2.jpg",
    "assets/image3.png",
    "assets/image4.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        fetchUserData(),
        fetchSessions(),
      ]);
    } catch (e) {
      if (mounted) {
        PopupSnackBar.showUnsuccessMessage(
            context, "Failed to initialize. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
Future<void> fetchSessions() async {
  try {
    if (user == null) {
      PopupSnackBar.showUnsuccessMessage(context, "User not authenticated");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var sessionsSnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('createdAt', descending: false)
        .get();

    if (mounted) {
      setState(() {
        _sessions = sessionsSnapshot.docs;
        _isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      PopupSnackBar.showUnsuccessMessage(
          context, "Failed to fetch sessions. Please try again.");
      print('Error fetching sessions: $e');
    }
  }
}
  
  Future<void> fetchUserData() async {
    try {
      if (user == null) return;

      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists && mounted) {
        setState(() {
          String fullName = snapshot.data()?['name'] ?? "UserName";
          userName = fullName.split(' ')[0];
        });
      }
    } catch (e) {
      if (mounted) {
        PopupSnackBar.showUnsuccessMessage(
            context, "Failed to fetch user data. Please try again.");
        print('Error fetching user data: $e');
      }
    }
  }

  Widget _buildCarouselItem(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        assetPath,
        fit: BoxFit.fill,
        width: double.infinity,
      ),
    );
  }

  Widget _buildSessionsList() {
    if (_sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No active sessions',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sessions.length,
      itemBuilder: (context, index) => buildSessionCard(_sessions[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xff1A5EBF),
          size: 30.0
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset(
            "assets/appbar.png",
            height: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      drawer:  SideMenu(),
      body: RefreshIndicator(
        color: const Color(0xff1A5EBF),
        onRefresh: _initializeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenWidth * 0.02
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1A5EBF),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          aspectRatio: 16 / 9,
                          scrollPhysics: const BouncingScrollPhysics(),
                        ),
                        items: _localImages.map(_buildCarouselItem).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Your Sessions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A5EBF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSessionsList(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}