import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telugram/services/firebase_service/firestore.dart';
import 'package:telugram/viewModels/image_cached.dart';
import 'package:telugram/views/widgets/comment.dart';
import 'package:telugram/views/widgets/like.dart';
import '../profile_screen.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  PostWidget({super.key, this.snapshot});
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
  }

  void _deletePost(String postId) async {
    try {
      await Firebase_Firestore().deletePost(postId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postingan berhasil dihapus'),
        ),
      );
    } catch (e) {
      // Handle error
      print("Error deleting post: $e");
    }
  }

  void _editPost(String postId, String newLocation, String newCaption) async {
    try {
      await Firebase_Firestore().updatePost(postId, newLocation, newCaption);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postingan berhasil diedit'),
        ),
      );
    } catch (e) {
      // Handle error
      print("Error editing post: $e");
    }
  }

  void _showEditBottomSheet() {
    TextEditingController locationController =
        TextEditingController(text: widget.snapshot['location']);
    TextEditingController captionController =
        TextEditingController(text: widget.snapshot['caption']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffD80032),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Lokasi",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                      labelText: "Caption",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Batal",
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          _editPost(widget.snapshot['postId'],
                              locationController.text, captionController.text);
                        },
                        child: const Text("Simpan",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPopupMenu() {
    if (widget.snapshot['uid'] != user) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Anda tidak memiliki izin untuk mengedit atau menghapus postingan ini.'),
        ),
      );
      return;
    }

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text(
            'Hapus',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _showEditBottomSheet();
      } else if (value == 'delete') {
        _showDeleteDialog();
      }
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Postingan"),
          content:
              const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _deletePost(widget.snapshot['postId']);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(Uid: widget.snapshot['uid']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: ListTile(
            leading: InkWell(
              onTap: _navigateToProfile,
              child: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
            ),
            title: InkWell(
              onTap: _navigateToProfile,
              child: Text(
                widget.snapshot['username'],
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
            subtitle: Text(
              widget.snapshot['location'],
              style: TextStyle(fontSize: 11.sp),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showPopupMenu,
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestore().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 375.w,
                height: 375.h,
                color: Colors.white,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: like(
                  child: Icon(
                    Icons.favorite,
                    size: 100.w,
                    color: Colors.red,
                  ),
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  like(
                    child: IconButton(
                        onPressed: () {
                          Firebase_Firestore().like(
                              like: widget.snapshot['like'],
                              type: 'posts',
                              uid: user,
                              postId: widget.snapshot['postId']);
                        },
                        icon: Icon(
                          widget.snapshot['like'].contains(user)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snapshot['like'].contains(user)
                              ? Colors.red
                              : Colors.black,
                          size: 24.w,
                        )),
                    isAnimating: widget.snapshot['like'].contains(user),
                  ),
                  SizedBox(width: 14.w),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.6,
                              minChildSize: 0.2,
                              builder: (context, scrollController) {
                                return Comment(
                                    widget.snapshot['postId'], 'posts');
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.mode_comment_outlined, size: 22.h),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Icon(Icons.bookmark_border_outlined, size: 25.h),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 17.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['like'].length.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['username'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.snapshot['caption'],
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 15.w, top: 05.h, bottom: 8.h),
                    child: Text(
                      formatDate(widget.snapshot['time'].toDate(),
                          [yyyy, '-', mm, '-', dd]),
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
