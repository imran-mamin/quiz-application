import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';

import 'package:first_project/constants/breakpoints.dart';
import 'package:first_project/constants/theme.dart';
import 'package:first_project/controllers/collection_controller.dart';
import 'package:first_project/screens/CollectionScreen.dart';
import 'package:first_project/screens/EditCollectionScreen.dart';
import 'package:first_project/screens/EditQuestionAndAnswerScreen.dart';
import 'package:first_project/screens/HomeScreen.dart';
import 'package:first_project/screens/LearnScreen.dart';
import 'package:first_project/screens/QuestionAndAnswerScreen.dart';
import 'package:first_project/screens/QuizScreen.dart';
import 'package:first_project/screens/ResultScreen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<CollectionController>(() => CollectionController());
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/collection", page: () => CollectionScreen()),
        GetPage(name: "/editcollection/:index", page: () => EditCollectionScreen()),
        GetPage(name: "/editcollection/qa/:index", page: () => QuestionAndAnswerScreen()),
        GetPage(name: "/editcollection/qa/:colIndex/:qaIndex", page: () => EditQuestionAndAnswerScreen()),
        GetPage(name: "/quiz/:colIndex/:qaIndex/:score", page: () => QuizScreen()),
        GetPage(name: "/learn/:index", page: () => LearnScreen()),
        GetPage(name: "/quiz/results/:score/total/:total", page: () => ResultScreen()),
      ],
    ),
  );
}

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < Breakpoints.sm;
}

bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final bool largerThanMobile = width >= Breakpoints.sm;
  final bool smallerThanLg = width < Breakpoints.lg;

  return largerThanMobile && smallerThanLg;
}

double setFontSize(BuildContext context) {
  if (isMobile(context)) {
    return 20.0;
  } else if (isTablet(context)) {
    return 40.0;
  } else {
    return 42.0;
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  
  DefaultAppBar({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Constants.appBarBackgroundColor,
      foregroundColor: Colors.white,
      title: Text(text),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DefaultBottomNavigationBar extends StatelessWidget {
  final List<Widget> children;
  
  DefaultBottomNavigationBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.appBarBackgroundColor,
      elevation: 8,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: this.children,
            ),
          ),
        ),
      ),
    );
  }
}
