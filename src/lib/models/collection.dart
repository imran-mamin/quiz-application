import 'package:get/get.dart';
import 'package:src/controllers/collection_controller.dart';
import 'dart:math';

import 'package:src/models/flashcard.dart';

class Collection {
  String name;
  RxList<QuestionAndAnswer> flashcards;

  Collection(this.name, List<QuestionAndAnswer> fc) : flashcards = fc.obs;

  // Set revise to 'true' if it is time to repeat a flashcard.
  void updateReviseLeitner() {
    final now = DateTime.timestamp();
    
    // Run through all flashcards and update their 'revise' property.
    for (final fc in flashcards) {
      final diff = now.difference(fc.lastRevisionDate.value);
      
      if (diff.inDays >= fc.revisionInterval.value) {
        fc.revise.value = true;
      } else {
        fc.revise.value = false;
      }
    }

    // Save changes in Hive.
    final collectionController = Get.find<CollectionController>();
    collectionController.persist();
  }

  /// This method updates revisionInterval and date for a single flashcard.
  /// Leitner algorithm is used to update revisionInterval. The idea of this
  /// algorithm is very simple:
  /// - When flashcard is created the revisionInterval is set to 0 and will
  /// be asked immediately.
  /// - When the user answers correctly, the revisionInterval will be set to 1.
  /// In other words this flashcard will be asked again after 1 day (24 hours).
  /// - If the user answers correctly again, then the revisionInterval will be
  /// multiplied by 2 with 256 being the upper bound for the revisionInterval.
  /// - If the user at any point answers incorrectly, then the revisionInterval
  /// will be reset to 0.
  /// Note: 256 was selected because it is less than one year (365 days) but still
  /// a multiple of 2. (256 = 2^8).
  Future<void> updateRevisionIntervalLeitner(QuestionAndAnswer fc, bool answeredCorrectly) async {
    assert(fc.revise.value == true, "This function should only be called during revision.");
    assert(fc.revisionInterval.value >= 0, "Revision interval should be either 0 or positive");
    if (answeredCorrectly) {
      fc.revise.value = false;
      final int revisionIntervalCandidate = fc.revisionInterval.value == 0 ? 1 : fc.revisionInterval.value * 2;
      fc.revisionInterval.value = min(256, revisionIntervalCandidate);
    } else {
      fc.revisionInterval.value = 0;
      fc.revise.value = true;
    }

    // Update date.
    fc.lastRevisionDate.value = DateTime.timestamp();

    // Save changes in Hive.
    final collectionController = Get.find<CollectionController>();
    await collectionController.persist();
  }

  /// SM-2 algorithm description taken from https://www.super-memory.com/english/ol/sm2.htm.
  /// "
  /// 1. Split the knowledge into smallest possible items.
  /// 2. With all items associate an E-Factor equal to 2.5.
  /// 3. Repeat items using the following intervals:
  /// I(1):=1
  /// I(2):=6
  /// for n>2: I(n):=I(n-1)*EF
  /// where:
  /// I(n) - inter-repetition interval after the n-th repetition (in days),
  /// EF - E-Factor of a given item
  /// If interval is a fraction, round it up to the nearest integer.
  /// 4. After each repetition assess the quality of repetition response in 0-5 grade scale:
  /// 5 - perfect response
  /// 4 - correct response after a hesitation
  /// 3 - correct response recalled with serious difficulty
  /// 2 - incorrect response; where the correct one seemed easy to recall
  /// 1 - incorrect response; the correct one remembered
  /// 0 - complete blackout.
  /// 5. After each repetition modify the E-Factor of the recently repeated item according to the formula:
  /// EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
  /// where:
  /// EF' - new value of the E-Factor,
  /// EF - old value of the E-Factor,
  /// q - quality of the response in the 0-5 grade scale.
  /// If EF is less than 1.3 then let EF be 1.3.
  /// 6. If the quality response was lower than 3 then start repetitions for the item from the beginning without changing the E-Factor
  /// (i.e. use intervals I(1), I(2) etc. as if the item was memorized anew).
  /// 7. After each repetition session of a given day repeat again all items that scored below four in the quality assessment.
  /// Continue the repetitions until all of these items score at least four.
  /// "
  /// 
  /// In this case, the SM-2 algorithm is used with small adjustment. Instead of grades 0-5, thumb up and down are
  /// used to assess the quality of repetition response. Thus, if the response is thumb up then a random grade is generated
  /// between [3, 5] and if the response is thumb down then a random number is generated between [0, 2].
  Future<void> updateRevisionIntervalSM2(QuestionAndAnswer fc, bool answeredCorrectly) async {
    assert(fc.revise.value == true, "This function should only be called during revision.");
    assert(fc.revisionInterval.value >= 0, "Revision interval should be either 0 or positive");
    assert(fc.repetitionNumber.value >= 0, "Number of repetitions should be nonnegative.");
    assert(fc.easinessFactor.value >= 0, "Easiness factor should be nonnegative");

    if (answeredCorrectly) {
      if (fc.repetitionNumber.value == 0) {
        fc.revisionInterval.value = 1; // I(1) = 1
      } else if (fc.repetitionNumber.value == 1) {
        fc.revisionInterval.value = 6; // I(2) = 6
      } else {
        // Round up to the nearest integer.
        fc.revisionInterval.value = (fc.revisionInterval.value * fc.easinessFactor.value).ceil();
      }

      fc.repetitionNumber++;
      fc.revise.value = false;
    } else {
      // "If the quality response was lower than 3 then start repetitions for the item from the beginning
      // without changing the E-Factor"
      fc.repetitionNumber.value = 0;
      fc.revisionInterval.value = 1;
      fc.revise.value = false;
    }

    // Instead of a real grade 0-5 a random number is used within that boundaries.
    // If answeredCorrectly is true, then the number is between [3, 5] and otherwise between [0, 2].
    DateTime now = DateTime.now();
    final int randomNumber = now.microsecond % 3; // A random number between [0, 2]
    final int grade = answeredCorrectly ? 3 + randomNumber : randomNumber;
    
    // Update easiness factor based on the grade.
    fc.easinessFactor.value = fc.easinessFactor.value + (0.1 - (5 - grade) * (0.08 + (5 - grade) * 0.02));
    if (fc.easinessFactor.value < 1.3) {
      fc.easinessFactor.value = 1.3;
    }

    // Update date.
    fc.lastRevisionDate.value = DateTime.timestamp();

    // Save changes in Hive.
    final collectionController = Get.find<CollectionController>();
    await collectionController.persist(); 
  }

  List<QuestionAndAnswer> shuffledFlashcards() {
    final List<QuestionAndAnswer> flashcardsCopy = [...flashcards];
    flashcardsCopy.shuffle();
    return flashcardsCopy;
  }

  List<QuestionAndAnswer> shuffledFlashcardsToRevise() {
    final List<QuestionAndAnswer> flashcardsToRevise = flashcards.where( (fc) => fc.revise.value == true ).toList();
    flashcardsToRevise.shuffle();
    return flashcardsToRevise;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'flashcards': flashcards.map( (fc) => fc.toJson()).toList(),
  };

  factory Collection.fromJson(Map json) {
    return Collection(
      json['name'],
      (json['flashcards'] as List).map( (item) => QuestionAndAnswer.fromJson(item) ).toList(),
    );
  }
}