class OpponentModel {
  String id;
  String name;
  int correct;
  int wrong;
  int totalSelectedAnswer;

  OpponentModel({
    required this.id,
    required this.name,
    required this.correct,
    required this.wrong,
    required this.totalSelectedAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'correct': correct,
      'wrong': wrong,
      'totalSelectedAnswer': totalSelectedAnswer
    };
  }
}
