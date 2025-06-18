import 'package:get/get.dart';
import 'package:first_project/models/flashcard.dart';

class Collection {
  String name;
  RxList<QuestionAndAnswer> flashcards;
  List<QuestionAndAnswer> shuffledFlashcards = [];

  Collection(this.name, List<QuestionAndAnswer> fc) : flashcards = fc.obs;

  void shuffleFlashcards() {
    shuffledFlashcards = [...flashcards];
    shuffledFlashcards.shuffle();
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'flashcards': flashcards.map( (fc) => fc.toJson()).toList(),
  };

  factory Collection.fromJson(Map json) {
    return Collection(
      json['name'],
      (json['flashcards'] as List).map( (item) => QuestionAndAnswer(question: item['question'], answer: item['answer'])).toList(),
    );
  }
}