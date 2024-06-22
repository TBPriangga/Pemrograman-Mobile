import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/services/firebase_service/firebase_storage.dart';
import 'package:telugram/services/firebase_service/firestore.dart';

import 'widgets/navbar.dart';

class AddPostTextScreen extends StatefulWidget {
  File _file;
  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool islooding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Postingan baru',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    islooding = true;
                  });
                  try {
                    String post_url = await StorageMethod()
                        .uploadImageToStorage('post', widget._file);
                    await Firebase_Firestore().CreatePost(
                      postImage: post_url,
                      caption: caption.text,
                      location: location.text,
                    );
                    setState(() {
                      islooding = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil upload'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Navbar(
                          initialIndex: 0,
                        ),
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    setState(() {
                      islooding = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal upload'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Bagikan',
                  style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: islooding
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                image: FileImage(widget._file),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 280.w,
                            height: 60.h,
                            child: TextField(
                              controller: caption,
                              decoration: const InputDecoration(
                                hintText: 'Tulis keterangan',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: 280.w,
                        height: 30.h,
                        child: TextField(
                          controller: location,
                          decoration: const InputDecoration(
                            hintText: 'Tambahkan Lokasi',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
