// ignore_for_file: must_be_immutable, unused_import

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/services/firebase_service/firebase_storage.dart';
import 'package:telugram/services/firebase_service/firestore.dart';
import 'package:video_player/video_player.dart';

class ReelsEditeScreen extends StatefulWidget {
  File videoFile;
  ReelsEditeScreen(this.videoFile, {super.key});

  @override
  State<ReelsEditeScreen> createState() => _ReelsEditeScreenState();
}

class _ReelsEditeScreenState extends State<ReelsEditeScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool Loading = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'Posting Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Loading
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : const Icon(Icons.send, color: Colors.black),
            onPressed: Loading
                ? null
                : () async {
                    setState(() {
                      Loading = true;
                    });
                    String Reels_Url = await StorageMethod()
                        .uploadImageToStorage('Reels', widget.videoFile);
                    await Firebase_Firestore().CreatReels(
                      video: Reels_Url,
                      caption: caption.text,
                    );
                    setState(() {
                      Loading = false;
                    });
                    Navigator.of(context).pop();
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: Loading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Container(
                          width: 270.w,
                          height: 420.h,
                          child: controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                )
                              : const CircularProgressIndicator()),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 60,
                      width: 280.w,
                      child: TextField(
                        controller: caption,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: 'Tulis Keterangan',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }
}
