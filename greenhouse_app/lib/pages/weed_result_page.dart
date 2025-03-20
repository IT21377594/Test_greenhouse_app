import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/weed_image_display.dart';

class ResultPage extends StatelessWidget {
  final File image;
  final List<dynamic> boxes;

  const ResultPage({super.key, required this.image, required this.boxes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detection Result"),
        backgroundColor: const Color(0xff083C27),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ImageDisplayPage(image: image, boxes: boxes),
      ),
    );
  }
}
