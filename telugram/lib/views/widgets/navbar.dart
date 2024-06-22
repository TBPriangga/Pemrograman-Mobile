import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/views/add_Screen.dart';
import 'package:telugram/views/explore_screen.dart';
import 'package:telugram/views/home_screen.dart';
import 'package:telugram/views/profile_screen.dart';
import 'package:telugram/views/reels_screen.dart';

class Navbar extends StatefulWidget {
  final int initialIndex;
  Navbar({super.key, this.initialIndex = 0});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: navigationTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const HomeScreen(),
          const ExploreScreen(),
          const AddScreen(),
          const ReelScreen(),
          ProfileScreen(
            Uid: _auth.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}
