class QuestionAndAnswer {
  String question;
  String answer;
  int revisionInterval;
  bool revise;
  // Date and time will be in UTC.
  DateTime lastRevisionDate;
  
  QuestionAndAnswer({required this.question, required this.answer, required this.revisionInterval, required this.revise, required this.lastRevisionDate});

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'revisionInterval': revisionInterval,
    'revise': revise,
    'lastRevisionDate': lastRevisionDate,
  };
}