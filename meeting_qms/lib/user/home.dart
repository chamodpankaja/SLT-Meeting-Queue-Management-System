import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeting_qms/service/notification_service.dart';
import 'package:meeting_qms/sign_in/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_qms/widgets/SessionCard.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meeting_qms/widgets/side_drawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "UserName";
  final User? user = FirebaseAuth.instance.currentUser;
  final List<String> _localImages = [
    "assets/image1.png",
    "assets/image2.jpg",
    "assets/image3.png",
    "assets/image4.jpeg",
  ];

  bool _isLoading = true;
   List<DocumentSnapshot> _sessions = [];

  Future<void> fetchSessions() async {
    try {
      setState(() => _isLoading = true);

      var sessionsSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .orderBy('createdAt', descending: false)
          .get();

      if (mounted) {
        setState(() {
          _sessions = sessionsSnapshot.docs;
        });
      }
    } catch (e) {
      if (mounted) {
        PopupSnackBar.showUnsuccessMessage(
            context, "Failed to fetch sessions. Please try again.");
        print('Error fetching sessions: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> fetchUserData() async {
    try {
      if (user != null) {
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
      }
    } catch (e) {
      if (mounted) {
        PopupSnackBar.showUnsuccessMessage(
            context, "Failed to fetch user data. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeHomePage();
    //_initializeNotifications();
  }

    Future<void> _initializeHomePage() async {
    try {
      await Future.wait([
        fetchUserData(),
        fetchSessions(),
      ]);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        PopupSnackBar.showUnsuccessMessage(
            context, "Failed to initialize. Please try again.");
      }
    }
  }

  Widget _buildCarouselItem(String assetPath) {
    return Builder(
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            assetPath,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        iconTheme: const IconThemeData(color: Color(0xff1A5EBF), size: 30.0),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset(
            "assets/appbar.png",
            height: 35,
          ),
        ),
      ),
      drawer: SideMenu(),
      body: RefreshIndicator(
        color: const Color(0xff1A5EBF),
        onRefresh: _initializeHomePage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
            child: Column(
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
                    'Available Sessions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A5EBF),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1A5EBF),
                    ),
                  )
                else if (_sessions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No sessions available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) => 
                      buildSessionCard(_sessions[index]),
                  ),
              ],
            ),
          ),
        ),
      ), 
    );
  }
}
  // Widget _buildSessionCard(DocumentSnapshot session) {
  //   final data = session.data() as Map<String, dynamic>;
  //   return Card(
  //     elevation: 3,
  //     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       side: BorderSide(color: Colors.blue.shade50),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   data['sessionName'] ?? 'Unnamed Session',
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF1A5EBF),
  //                   ),
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               Text(
  //                 data['time'] ?? '',
  //                 style: TextStyle(
  //                   color: Colors.grey.shade600,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               const Icon(Icons.location_on_outlined, 
  //                 color: Color(0xFF1A5EBF), size: 16),
  //               const SizedBox(width: 4),
  //               Text(
  //                 data['venue'] ?? 'No venue specified',
  //                 style: TextStyle(color: Colors.grey.shade700),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               const Icon(Icons.calendar_today_outlined, 
  //                 color: Color(0xFF1A5EBF), size: 16),
  //               const SizedBox(width: 4),
  //               Text(
  //                 data['date'] ?? '',
  //                 style: TextStyle(color: Colors.grey.shade700),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Wrap(
  //             spacing: 8,
  //             runSpacing: 8,
  //             children: (data['techStacks'] as List<dynamic>?)?.map((tech) =>
  //               Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFF1A5EBF).withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   tech.toString(),
  //                   style: const TextStyle(
  //                     color: Color(0xFF1A5EBF),
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ),
  //             ).toList() ?? [],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }