import 'package:flutter/material.dart';

import 'widgets/postingan.dart';

class PostScreen extends StatelessWidget {
  final snapshot;
  PostScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: PostWidget(snapshot: snapshot)),
    );
  }
}
