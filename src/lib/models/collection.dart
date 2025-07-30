import 'package:get/get.dart';
import 'package:src/controllers/collection_controller.dart';
import 'dart:math';

import 'package:src/models/flashcard.dart';

class Collection {
  String name;
  RxList<QuestionAndAnswer> flashcards;

  Collection(this.name, List<QuestionAndAnswer> fc) : flashcards = fc.obs;

  // This method is an algorithm for flashcard repetition.
  void updateRevisionTimes() {
    final now = DateTime.timestamp();
    
    for (final fc in flashcards) {
      final diff = now.difference(fc.lastRevisionDate.value);
      
      if (diff.inDays >= fc.revisionInterval.value) {
        fc.revise.value = true;
      } else {
        fc.revise.value = false;
      }
    }

    final collectionController = Get.find<CollectionController>();
    // TODO: Come up with a more elegant way of notifying Hive about changes in collection.
    final collectionIndex = collectionController.collections.indexWhere( (c) => c.name == name );
    final updatedCollection = Collection(name, flashcards);
    collectionController.updateCollection(collectionIndex, updatedCollection);
  }

  // This method updates revisionInterval and date for a single flashcard.
  void updateRevisionInterval(QuestionAndAnswer fc, bool answeredCorrectly) {
    if (answeredCorrectly) {
      if (fc.revisionInterval.value == 0) {
        fc.revise.value = false;
        fc.revisionInterval.value = 1;
      } else {
        fc.revise.value = false;
        fc.revisionInterval.value = min(365, fc.revisionInterval.value * 2);
      }
    } else {
      fc.revisionInterval.value = 0;
      fc.revise.value = true;
    }

    fc.lastRevisionDate.value = DateTime.timestamp();

    final collectionController = Get.find<CollectionController>();
    // TODO: Come up with a more elegant way of notifying Hive about changes in collection.
    final collectionIndex = collectionController.collections.indexWhere( (c) => c.name == name );
    final updatedCollection = Collection(name, flashcards);
    collectionController.updateCollection(collectionIndex, updatedCollection);
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