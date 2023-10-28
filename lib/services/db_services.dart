import 'package:cloud_firestore/cloud_firestore.dart';

class DBServices {
  Stream<List<QuestionModel>> getItems() {
    CollectionReference items = FirebaseFirestore.instance.collection('quiz');
    return items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuestionModel(
            question: doc['question'],
            answer: doc['answer'],
            option: doc['option']);
      }).toList();
    });
  }
}

class QuestionModel {
  final String question;
  final String answer;
  final List<dynamic> option;

  QuestionModel(
      {required this.question, required this.answer, required this.option});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'option': option,
    };
  }
}
