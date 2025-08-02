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
  void updateRevisionIntervalLeitner(QuestionAndAnswer fc, bool answeredCorrectly) {
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
    collectionController.persist();
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