import 'package:get/get.dart';

class QuestionAndAnswer {
  RxString question;
  RxString answer;
  RxInt revisionInterval;
  RxBool revise;
  // Date and time will be in UTC.
  Rx<DateTime> lastRevisionDate;
  
  QuestionAndAnswer({
    required String question,
    required String answer,
    required int revisionInterval,
    required bool revise,
    required DateTime lastRevisionDate,
  }) :
    question = question.obs,
    answer = answer.obs,
    revisionInterval = revisionInterval.obs,
    revise = revise.obs,
    lastRevisionDate = lastRevisionDate.obs;
  
  Map<String, dynamic> toJson() {
    print("revisionInterval = $revisionInterval");
    return {
    'question': question.value,
    'answer': answer.value,
    'revisionInterval': revisionInterval.value,
    'revise': revise.value,
    'lastRevisionDate': lastRevisionDate.value,
  };}

  factory QuestionAndAnswer.fromJson(Map json) => QuestionAndAnswer(
    question: json['question'],
    answer: json['answer'],
    revisionInterval: json['revisionInterval'],
    revise: json['revise'],
    lastRevisionDate: json['lastRevisionDate'],
  );
}