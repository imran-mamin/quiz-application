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

  /// Test Leitner algorithm.
  test('Collection "test" has one flashcard with revisionInterval set to 0 and the user answers incorrectly', () async {
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
    
    final Collection testCollection = Collection("test", fcs);
    expect(testCollection.flashcards.length, 1);
    
    await testCollection.updateRevisionIntervalLeitner(fcs.first, false);
    expect(fcs.first.revise.value, true);
    expect(fcs.first.revisionInterval.value, 0);
  });

  test('Collection "test" has one flashcard with revisionInterval set to 0 and the user answers correctly', () async {
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

  test('Collection "test" has one flashcard with revisionInterval set to 1 and the user answers incorrectly', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 1,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, false);

    expect(fcs.first.revise.value, true);
    expect(fcs.first.revisionInterval.value, 0);
  });

  test('Collection "test" has one flashcard with revisionInterval set to 1 and the user answers correctly', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 1,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, true);

    expect(fcs.first.revise.value, false);
    expect(fcs.first.revisionInterval.value, 2);
  });

  test('Flashcard with revisionInterval set to 2 and the user answers incorrectly', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 2,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, false);

    expect(fcs.first.revise.value, true);
    expect(fcs.first.revisionInterval.value, 0);
  });

  test('Flashcard with revisionInterval set to 2 and the user answers correctly', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 2,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, true);

    expect(fcs.first.revise.value, false);
    expect(fcs.first.revisionInterval.value, 4); // Since in the case of revisionInterval == 2, it should be doubled.
  });

  test('Leitner should work even though revisionInterval is not a multiple of 2', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 127, // Just a random odd number.
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, true);

    expect(fcs.first.revise.value, false);
    expect(fcs.first.revisionInterval.value, 254); // 127 * 2 = 254
  });

  test('The upper bound for revisionInterval should be 256', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 1813, // Some random odd number that is greater than 256
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, true);

    expect(fcs.first.revise.value, false);
    expect(fcs.first.revisionInterval.value, 256);
  });

  test('In case the answer is incorrect the revisionInterval should be set back to 0', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 518,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalLeitner(fcs.first, false);

    expect(fcs.first.revise.value, true);
    expect(fcs.first.revisionInterval.value, 0);
  });

  /// Test SM-2 algorithm
  test('Interval should be set to 1, if it is initially 0, repetition number is 0 and answer is incorrect', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 0,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 0,
        easinessFactor: 2.5,
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalSM2(fcs.first, false);

    expect(fcs.first.revisionInterval.value, 1);
    expect(fcs.first.revise.value, false);
    expect(fcs.first.repetitionNumber.value, 0);
  });

  test('Interval should be set to 1, if it is initially greater than 0, repetition number is not 0 and answer is incorrect', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 2,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 6,
        easinessFactor: 2.5,
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalSM2(fcs.first, false);

    expect(fcs.first.revisionInterval.value, 1);
    expect(fcs.first.revise.value, false);
    expect(fcs.first.repetitionNumber.value, 0);
  });

  test('Interval should be set to 6, if repetitionNumber is 1 and the answer is correct', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 2,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 1,
        easinessFactor: 2.5,
      ),
    ];
    
    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalSM2(fcs.first, true);

    expect(fcs.first.revisionInterval.value, 6);
    expect(fcs.first.revise.value, false);
    expect(fcs.first.repetitionNumber.value, 2);
  });

  test('When repetitionNumber is greater than 1 and the answer is correct then revision interval should be set to round(current revision interval * EF)', () async {
    final List<QuestionAndAnswer> fcs = [
      QuestionAndAnswer(
        question: "question1",
        answer: "answer1",
        revisionInterval: 8,
        revise: true,
        lastRevisionDate: DateTime.timestamp(),
        repetitionNumber: 2,
        easinessFactor: 2.5,
      ),
    ];

    final Collection testCollection = Collection('test', fcs);
    await testCollection.updateRevisionIntervalSM2(fcs.first, true);

    // roundup(8 (revisionInterval) * 2.5 (easinessFactor)).
    expect(fcs.first.revisionInterval.value, (8 * 2.5).ceil());
    expect(fcs.first.revise.value, false);
    expect(fcs.first.repetitionNumber.value, 3);
  });
}
