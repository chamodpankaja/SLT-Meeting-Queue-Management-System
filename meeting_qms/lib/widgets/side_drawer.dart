import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting_qms/sign_in/sign_in.dart';


class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "User";
  String userEmail = "Loading...";
  //String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['name'] ?? 'User';
          userEmail = snapshot.data()?['email'] ?? 'No Email';
          //profilePicUrl = snapshot.data()?['profilePic'] ?? '';
        });
      }
    }
  }

  // void navigateToPage(int index) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MainScreen(selectedIndex: index),
  //     ),
  //   );
  // }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), 
          ),
          titlePadding: EdgeInsets.all(20), 
          title: Center(
            child: Text(
              'Are you sure you want to sign out?',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              
            ),
          ),
          contentPadding: EdgeInsets.zero, 
          actionsPadding: EdgeInsets.zero, 
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade400, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16), 
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5), 
                        child: Text('No',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(
                        backgroundColor:  Color(0xff1A5EBF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16), 
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Yes',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, 
        child: Column(
          children: [
            Container(
              width: double.infinity, 
              color: Colors.blue.shade50, 
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ProfilePage()),
                      // );
                    },
                    child: CircleAvatar(
                      radius: 40, // Avatar size
                      //backgroundImage: profilePicUrl.isNotEmpty
                         // ? NetworkImage(profilePicUrl)
                        //  : AssetImage('lib/assets/images/default_profile.jpg') as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      color:  Color(0xff1A5EBF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 14, color:  Color(0xff1A5EBF)),
                  ),
                ],
              ),
            ),
            // Navigation Items
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Color(0xff1A5EBF)),
                    title: Text("Home", style: TextStyle(color: Colors.black87)),
                    onTap: () {
                       Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark, color: Color(0xff1A5EBF)),
                    title: Text("Favourites", style: TextStyle(color: Color(0xff1A5EBF))),
                    onTap: () {
                      //navigateToPage(1);
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritesScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cloud, color: Color(0xFF0B5739)),
                    title: Text("Weather", style: TextStyle(color: Color(0xFF0B5739))),
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map, color: Color(0xFF0B5739)),
                    title: Text("Map", style: TextStyle(color: Color(0xFF0B5739))),
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                    },
                  ),
                  
                  ListTile(
                    leading: Icon(Icons.settings, color: Color(0xFF0B5739)),
                    title: Text("Settings", style: TextStyle(color: Color(0xFF0B5739))),
                    onTap: () {
                      //navigateToPage(4);
                    },
                  ),
                  Divider(color: Colors.black12),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.redAccent),
                    title: Text("Logout", style: TextStyle(color: Colors.redAccent)),
                    onTap: () async {
                      await _confirmSignOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}