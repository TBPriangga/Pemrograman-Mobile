import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/services/firebase_service/firestore.dart';
import 'package:video_player/video_player.dart';
import '../model/user_model.dart';
import '../viewModels/image_cached.dart';
import 'widgets/reels.dart';
import 'editprofile_screen.dart';
import 'post_screen.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String Uid;
  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  bool yourse = false;
  List following = [];
  bool follow = false;
  int followersCount = 0;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getdata();
    if (widget.Uid == _auth.currentUser!.uid) {
      setState(() {
        yourse = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  getdata() async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(widget.Uid).get();
    setState(() {
      followersCount = (snap.data()! as dynamic)['followers'].length;
      following = (snap.data()! as dynamic)['following'];
      follow = (snap.data()! as dynamic)['followers']
          .contains(_auth.currentUser!.uid);
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(show: () {})),
    );
  }

  Future<void> _followUser() async {
    await Firebase_Firestore().follow(uid: widget.Uid);
    setState(() {
      follow = true;
      followersCount++;
    });
  }

  Future<void> _unfollowUser() async {
    await Firebase_Firestore().unfollow(uid: widget.Uid);
    setState(() {
      follow = false;
      followersCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _logout();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: Firebase_Firestore().getUser(UID: widget.Uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Head(snapshot.data!);
                },
              ),
              Container(
                color: Colors.grey,
                child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  tabs: [
                    SizedBox(
                      height: 30.w,
                      child: Icon(Icons.grid_on),
                    ),
                    SizedBox(
                      height: 30.w,
                      child: Icon(Icons.video_collection),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    StreamBuilder(
                      stream: _firebaseFirestore
                          .collection('posts')
                          .where('uid', isEqualTo: widget.Uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        post_lenght = snapshot.data!.docs.length;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: post_lenght,
                          itemBuilder: (context, index) {
                            final snap = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PostScreen(snap.data())));
                              },
                              child: CachedImage(
                                snap['postImage'],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: _firebaseFirestore
                          .collection('reels')
                          .where('uid', isEqualTo: widget.Uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final snap = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ReelsItem(snap.data())));
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    color: Colors.black,
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: VideoPlayer(
                                        VideoPlayerController.network(
                                          snap['reelsvideo'],
                                        )..initialize(),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 50.w,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Head(Usermodel user) {
    return Stack(
      children: [
        Container(
          color: Colors.red,
          height: 150.h,
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Text(
                user.username,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Postingan ',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Pengikut',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        followersCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Mengikuti',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                user.bio,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              if (!yourse)
                follow
                    ? Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _unfollowUser,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5.r),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: const Text('Berhenti Mengikuti'),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const Text(
                                'Pesan',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _followUser,
                        child: Container(
                          alignment: Alignment.center,
                          height: 30.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: const Text(
                            'Ikuti',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              if (yourse)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        onSave: () {
                          setState(() {
                            getdata();
                          });
                        },
                      ),
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Text('Sunting Profile'),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 10.h,
          left: MediaQuery.of(context).size.width / 2 - 50.w,
          child: ClipOval(
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: CachedImage(user.profile),
            ),
          ),
        ),
      ],
    );
  }
}
