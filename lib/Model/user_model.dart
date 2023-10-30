class UserModel {
  String id;
  String email;
  String name;
  int correct;
  int wrong;
  int totalSelectedAnswer;
  bool isBusy;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.correct,
    required this.wrong,
    required this.totalSelectedAnswer,
    required this.isBusy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'correct': correct,
      'wrong': wrong,
      'totalSelectedAnswer': totalSelectedAnswer,
      'isBusy': isBusy,
    };
  }
}
