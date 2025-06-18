class QuestionAndAnswer {
  String question;
  String answer;

  QuestionAndAnswer({required this.question, required this.answer});

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
  };
}