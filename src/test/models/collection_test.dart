import 'package:src/models/flashcard.dart';
import 'package:test/test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:src/models/collection.dart';
import 'package:src/controllers/collection_controller.dart';

Future<void> initControllerAndHive() async {
  await setUpTestHive();
  await Hive.openBox("storage");
  Get.put(CollectionController());
}

void main() {
  /// setUpAll and tearDownAll are used to avoid race condition that happens
  /// if setUp and tearDown are used instead.
  /// The setUpAll function runs only once before any of the tests in the main group,
  /// and tearDownAll runs only once after all tests have completed.
  setUpAll(() async {
    await initControllerAndHive();
  });

  tearDownAll(() async {
    await Hive.close();
    await tearDownTestHive();
  });

  test('Initialize collection named "hello" with one flashcard', () {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 0,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];
    
    final Collection helloCollection = Collection("hello", fcs);
    expect(helloCollection.flashcards.length, 1);
  });

  test('Test Leitner algorithm with one flashcard', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 0,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, true);

    expect(fcs.first.revise.value, false);
    expect(fcs.first.revisionInterval.value, 1);
  });
}