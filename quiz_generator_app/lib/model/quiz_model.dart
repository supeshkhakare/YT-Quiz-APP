class AutoGenerate {
  AutoGenerate({required this.quiz});
  late final List<Quiz> quiz;

  AutoGenerate.fromJson(Map<String, dynamic> json) {
    quiz = List.from(json['quiz']).map((e) => Quiz.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['quiz'] = quiz.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Quiz {
  Quiz({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
  late final String question;
  late final List<String> options;
  late final int correctIndex;

  Quiz.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = List.castFrom<dynamic, String>(json['options']);
    correctIndex = json['correctIndex'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['question'] = question;
    _data['options'] = options;
    _data['correctIndex'] = correctIndex;
    return _data;
  }
}
