import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get/get.dart';

import 'package:src/screens/CollectionScreen.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/main.dart';

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

  testWidgets('AppBar has a text "Create A New Collection"', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CollectionScreen(),
      ),
    );

    final appBar = find.byType(AppBar);
    final titleText = find.descendant(of: appBar, matching: find.text('Create A New Collection'));
    expect(titleText, findsOneWidget);
  });

  testWidgets('Has a form for providing a collection name', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CollectionScreen(),
      ),
    );

    final formBuilder = find.byType(FormBuilder);
    final textFieldTitle = find.descendant(of: formBuilder, matching: find.text('Collection Name:'));
    expect(textFieldTitle, findsOne);
  });
  
  testWidgets('BottomNavigationBar has two buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: CollectionScreen(),
      ),
    );

    final bottomNavBar = find.byType(DefaultBottomNavigationBar);
    final arrowBackIcon = find.descendant(of: bottomNavBar, matching: find.byIcon(Icons.arrow_back_rounded));
    final saveText = find.descendant(of: bottomNavBar, matching: find.text('Save'));

    expect(arrowBackIcon, findsOne);
    expect(saveText, findsOne);
  });
}
