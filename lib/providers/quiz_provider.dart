import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _current = 0;
  int _correct = 0;

  final Duration perQuestion = const Duration(seconds: 15);
  Duration _remainingQuestion = Duration.zero;
  Duration _remainingTotal   = Duration.zero;
  Timer? _questionTimer;
  Timer? _totalTimer;

  List<Question> get questions => _questions;
  int get current => _current;
  int get correct => _correct;
  String _playerName = '';
  Duration get remainingQuestion => _remainingQuestion;
  Duration get remainingTotal => _remainingTotal;


  Future<void> loadQuestions(BuildContext context) async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('lib/data/questions.json');
    final decoded = List<Map<String, dynamic>>.from(jsonDecode(data));
    _questions = decoded.map(Question.fromJson).toList();
    notifyListeners();
  }

  String get playerName => _playerName;
  void setPlayerName(String name) {
    _playerName = name.trim();
    notifyListeners();
  }

  void startQuiz() {
    _current = 0;
    _correct = 0;
    _remainingQuestion = perQuestion;
    _remainingTotal =
        Duration(seconds: (perQuestion.inSeconds * _questions.length)- 20);
    _startQuestionTimer();
    _startTotalTimer();
    notifyListeners();
  }

  void answer(int selected) {
    if (selected >= 0 &&
        selected == _questions[_current].correctIndex) _correct++;
    _next();
  }

  void _next() {
    _current++;
    _questionTimer?.cancel();

    if (_current < _questions.length) {
      _remainingQuestion = perQuestion;
      _startQuestionTimer();
    } else {
      _stopAllTimers();
    }
    notifyListeners();
  }

  void _startQuestionTimer() {
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingQuestion.inSeconds > 0) {
        _remainingQuestion -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        t.cancel();
        answer(-1);
      }
    });
  }

  void _startTotalTimer() {
    _totalTimer?.cancel();
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingTotal.inSeconds > 0) {
        _remainingTotal -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        t.cancel();
        _stopAllTimers();
        _current = _questions.length;
        notifyListeners();
      }
    });
  }

  void _stopAllTimers() {
    _questionTimer?.cancel();
    _totalTimer?.cancel();
  }

  void reset() {
    _stopAllTimers();
    _current = 0;
    _correct = 0;
  }
}
