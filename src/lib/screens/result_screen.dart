import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:src/constants/theme.dart';
import 'package:src/main.dart';

String motivatingText() {
  // Generate a random number between 0..3.
  final int randomNumber = Random().nextInt(4); 

  if (randomNumber == 0) {
    return "🎉 Perfect score! 🎉";
  } else if (randomNumber == 1) {
    return "👏 Great job! You're doing really well!";
  } else if (randomNumber == 2) {
    return "👍 Good effort! Keep practicing!";
  } else {
    return "💪 Don't give up! Keep learning!";
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "🎉 Done for today 🎉"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                  const SizedBox(height: 24),
                  Text(
                    motivatingText(),
                    style: TextStyle(
                      fontSize: setFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Constants.textColorOnCanvas,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    // Return back to HomeScreen.
                    onPressed: () => Get.offNamed('/'),
                    icon: const Icon(Icons.home),
                    label: const Text("Back Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}