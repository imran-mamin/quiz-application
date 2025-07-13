import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:first_project/main.dart';
import 'package:first_project/controllers/displaypicture_controller.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const DisplayPictureScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    final displaypictureController = Get.find<DisplayPictureController>();
    
    return Scaffold(
      appBar: DefaultAppBar(text: 'Display the Picture'),
      body: Center(
        child: Image.memory(imageBytes),
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  displaypictureController.send.value = false;
                  Get.back();
                },
                child: Icon(Icons.arrow_back_rounded),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  displaypictureController.send.value = true;
                  Get.back();
                },
                child: Text("Ok"),
              ),
            ),
          ],
        ),
    );
  }
}