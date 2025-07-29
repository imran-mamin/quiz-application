import 'package:get/get.dart';

import 'package:src/models/flashcard.dart';

class Collection {
  String name;
  RxList<QuestionAndAnswer> flashcards;

  Collection(this.name, List<QuestionAndAnswer> fc) : flashcards = fc.obs;

  // This method is an algorithm for flashcard repetition.
  void updateRevisionTimes() {
    final now = DateTime.timestamp();
    
    for (final fc in flashcards) {
      final diff = now.difference(fc.lastRevisionDate);
      
      if (diff.inDays >= fc.revisionInterval) {
        fc.revise = true;
      } else {
        fc.revise = false;
      }
    }
  }

  // This method updates revisionInterval for a single flashcard.
  void updateRevisionInterval(QuestionAndAnswer fc, bool answeredCorrectly) {
    if (answeredCorrectly) {
      if (fc.revisionInterval == 0) {
        fc.revise = false;
        fc.revisionInterval = 1;
      } else {
        fc.revise = false;
        fc.revisionInterval *= 2;
      }
    } else {
      fc.revisionInterval = 0;
      fc.revise = true;
    }

    fc.lastRevisionDate = DateTime.timestamp();
  }

  List<QuestionAndAnswer> shuffledFlashcardsToRevise() {
    final List<QuestionAndAnswer> flashcardsToRevise = flashcards.where( (fc) => fc.revise == true ).toList();
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
      (json['flashcards'] as List).map( (item) =>
        QuestionAndAnswer(
          question: item['question'],
          answer: item['answer'],
          revisionInterval: item['revisionInterval'],
          revise: item['revise'],
          lastRevisionDate: item['lastRevisionDate']
        )).toList(),
    );
  }
}