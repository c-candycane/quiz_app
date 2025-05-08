import 'package:flutter/cupertino.dart';
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  late final List<Question> _questions;
  int _current = 0;
  int _correct = 0;
  Duration perQuestion = const Duration(seconds: 15);

  // getter’lar …

  void answer(int selected) {
    if (selected == _questions[_current].correctIndex) _correct++;
    _next();
  }

  void _next() {
    _current++;
    notifyListeners();
  }
}
