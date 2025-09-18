import 'package:flutter/cupertino.dart';

class SurveyProvider extends ChangeNotifier {
  final Map<int, dynamic> _currentAnswers = {};
  final List<Map<int, dynamic>> _allResponses = [];
  final Map<int, String?> _errors = {};
  final Map<int, TextEditingController> _controllers = {};
  List<dynamic> _questions = [];

  Map<int, dynamic> get currentAnswers => _currentAnswers;
  List<Map<int, dynamic>> get allResponses => _allResponses;
  Map<int, String?> get errors => _errors;
  List<dynamic> get questions => _questions;

  void setQuestions(List<dynamic> qs) {
    _questions = qs;
    notifyListeners();
  }

  TextEditingController getController(int questionId) {
    if (!_controllers.containsKey(questionId)) {
      _controllers[questionId] = TextEditingController();
    }
    return _controllers[questionId]!;
  }

  void updateAnswer(int questionId, dynamic value) {
    _currentAnswers[questionId] = value;
    _errors[questionId] = null;
    notifyListeners();
  }

  bool validateAnswers(List<dynamic> questions) {
    bool isValid = true;
    _errors.clear();

    for (var q in questions) {
      if (q['required'] == true) {
        final answer = _currentAnswers[q['id']];
        if (answer == null || (answer is String && answer.trim().isEmpty)) {
          _errors[q['id']] = "This field is required";
          isValid = false;
        }
      }
    }

    notifyListeners();
    return isValid;
  }

  void submitResponse() {
    if (_currentAnswers.isNotEmpty) {
      _allResponses.add(Map<int, dynamic>.from(_currentAnswers));
      _currentAnswers.clear();
      _errors.clear();
      for (var c in _controllers.values) {
        c.clear();
      }
      notifyListeners();
    }
  }
}
