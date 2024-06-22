import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/postingan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: SizedBox(
            width: 105.w,
            height: 28.h,
            child: Image.asset(
              'assets/logo/miniLogo1.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 25,
          ),
          SizedBox(width: 15.w),
          const Icon(
            Icons.favorite_border_rounded,
            color: Colors.white,
            size: 24.0,
          ),
          SizedBox(width: 15.w),
        ],
        backgroundColor: const Color(0xffD80032),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: _firebaseFirestore
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: const CircularProgressIndicator());
                    }
                    return PostWidget(
                        snapshot: snapshot.data!.docs[index].data());
                  },
                  childCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
