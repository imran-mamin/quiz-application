import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get/get.dart';

import 'package:src/screens/HomeScreen.dart';
import 'package:src/controllers/collection_controller.dart';

Future<void> initControllerAndHive() async {
  await setUpTestHive();
  await Hive.openBox("storage");
  Get.put(CollectionController());
}

void main() {
  setUp(() async {
    await initControllerAndHive();
  });

  tearDown(() async {
    await Hive.close();
  });

  testWidgets('Contains text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    final collectionNameText = find.text('No collections');
    expect(collectionNameText, findsOneWidget);
  });
}
