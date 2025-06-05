import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meeting_qms/sign_in/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_qms/widgets/popupMsgs/snackBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meeting_qms/widgets/side_drawer.dart';

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
  }

  Future<void> _initializeHomePage() async {
    try {
      await fetchUserData();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
      // appBar: AppBar(
      //   // title: Text('Welcome User: $userName'),
      //    backgroundColor: const Color(0xff1A5EBF),

      //   flexibleSpace: Stack(
      //     children: [
      //       Center(
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 10),
      //           child: Image.asset(
      //             "assets/appbar.png",
      //             height: 35,
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      appBar: AppBar(
       // backgroundColor: const Color(0xff1A5EBF),
       backgroundColor: Colors.blue.shade50,
       iconTheme: IconThemeData(color: Color(0xff1A5EBF),size: 30.0),
        centerTitle: true, // This is crucial to center the title
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset(
            "assets/appbar.png",
            height: 35,
          ),
          
        ),
        
      ),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
          child: Column(
            children: [
              if (_isLoading)
                const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xff1A5EBF),
                ))
              else
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
            ],
          ),
        ),
      ),
    );
  }
}
