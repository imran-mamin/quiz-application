import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'package:src/constants/breakpoints.dart';
import 'package:src/constants/theme.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/screens/CollectionScreen.dart';
import 'package:src/screens/EditCollectionScreen.dart';
import 'package:src/screens/EditQuestionAndAnswerScreen.dart';
import 'package:src/screens/HomeScreen.dart';
import 'package:src/screens/LearnScreen.dart';
import 'package:src/screens/QuestionAndAnswerScreen.dart';
import 'package:src/screens/QuizScreen.dart';
import 'package:src/screens/ResultScreen.dart';

Future<void> initAppForMain() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<CollectionController>(() => CollectionController());
}

late List<CameraDescription> cameras;

Future<void> main() async {
  // Ensure that plugin services are initialized so that 'availableCameras()'
  // can be called before 'runApp()'.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive.
  await initAppForMain();

  if (!kIsWeb) {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
  }

  final CollectionController collectionController = Get.find<CollectionController>();
  collectionController.updateTimeStampsInFlashcards();

  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/collection", page: () => CollectionScreen()),
        GetPage(name: "/editcollection/:index", page: () => EditCollectionScreen()),
        GetPage(name: "/editcollection/qa/:index", page: () => QuestionAndAnswerScreen()),
        GetPage(name: "/editcollection/qa/:colIndex/:qaIndex", page: () => EditQuestionAndAnswerScreen()),
        GetPage(name: "/quiz/:colIndex", page: () => QuizScreen()),
        GetPage(name: "/learn/:index", page: () => LearnScreen()),
        GetPage(name: "/results", page: () => const ResultScreen()),
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
