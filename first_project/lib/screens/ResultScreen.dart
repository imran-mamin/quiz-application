import 'dart:async';
import 'dart:io';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';

import 'package:first_project/constants/theme.dart';
import 'package:first_project/main.dart';

String resultText(int score, int total) {
  double ratio = score / total;

  if (ratio == 1.0) {
    return "🎉 Perfect score! 🎉";
  } else if (ratio >= 0.75) {
    return "👏 Great job! You're doing really well!";
  } else if (ratio >= 0.50) {
    return "👍 Good effort! Keep practicing!";
  } else if (ratio > 0) {
    return "💪 Don't give up! Keep learning!";
  } else {
    return "😅 Let's try again and do better!";
  }
}

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scoreStr = Get.parameters['score'];
    final score = int.tryParse(scoreStr ?? '');

    if (score == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error")
        ),
        body: Center(child: Text("Invalid quiz score")),
      );
    }

    final totalStr = Get.parameters['total'];
    final total = int.tryParse(totalStr ?? '');

    if (total == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: Constants.appBarBackgroundColor,
          title: Text("Error")
        ),
        body: Center(child: Text("Invalid amount of total amount of flashcards")),
      );
    }

    return Scaffold(
      appBar: DefaultAppBar(text: "Result"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
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
                  Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                  SizedBox(height: 24),
                  Text(
                    resultText(score, total),
                    style: TextStyle(
                      fontSize: setFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "You scored",
                    style: TextStyle(fontSize: setFontSize(context), color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "$score out of $total",
                    style: TextStyle(
                      fontSize: setFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Get.offNamed('/'),
                    icon: Icon(Icons.home),
                    label: Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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