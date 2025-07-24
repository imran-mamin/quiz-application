import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get/get.dart';

import 'package:src/screens/HomeScreen.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/models/collection.dart';

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

  testWidgets('AppBar has a text "Quiz Application"', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    final appBar = find.byType(AppBar);
    final titleText = find.descendant(of: appBar, matching: find.text('Quiz Application'));
    expect(titleText, findsOneWidget);
  });

  testWidgets('Displays text "No collections" when there are no collections created', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );
    
    final noCollectionsText = find.text("No collections");
    expect(noCollectionsText, findsOneWidget);
  });

  testWidgets('Create a collection and check its name', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    final collectionController = Get.find<CollectionController>();

    const collectionName = "Empty";
    final emptyCollection = Collection(collectionName, []); // Collection(String name, List<QuestionAndAnswer> fc)
    collectionController.collections.add(emptyCollection);

    // Rebuild the widget after adding a new collection.
    await tester.pumpAndSettle();

    final listTile = find.byType(ListTile);
    final titleText = find.descendant(of: listTile, matching: find.text(collectionName));
    expect(titleText, findsOne);

    final subTitleText = find.descendant(of: listTile, matching: find.text("Size: ${emptyCollection.flashcards.length} flashcards"));
    expect(subTitleText, findsOne);
  
    // Remove collection from collectionController.
    collectionController.collections.remove(emptyCollection);
  });

  testWidgets('A single collection has four iconButtons in HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    final collectionController = Get.find<CollectionController>();

    const collectionName = "Empty";
    final emptyCollection = Collection(collectionName, []); // Collection(String name, List<QuestionAndAnswer> fc)
    collectionController.collections.add(emptyCollection);

    // Rebuild the widget after adding a new collection.
    await tester.pumpAndSettle();

    final listTile = find.byType(ListTile);
    final schoolIcon = find.descendant(of: listTile, matching: find.byIcon(Icons.school));
    final menuBookIcon = find.descendant(of: listTile, matching: find.byIcon(Icons.menu_book));
    final editIcon = find.descendant(of: listTile, matching: find.byIcon(Icons.edit));
    final deleteIcon = find.descendant(of: listTile, matching: find.byIcon(Icons.delete));

    expect(schoolIcon, findsOne);
    expect(menuBookIcon, findsOne);
    expect(editIcon, findsOne);
    expect(deleteIcon, findsOne);

    // Remove collection from collectionController.
    collectionController.collections.remove(emptyCollection);
  });
}
