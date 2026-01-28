import 'package:flutter/foundation.dart';
import '../models/isi_question.dart';
import '../models/detection_result.dart';
import '../services/firestore_service.dart';

/// Provider for ISI Questionnaire state management
class ISIProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // State for current answers
  final Map<int, int> _answers = {}; // questionId -> selectedScore
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  DetectionResult? _lastResult;

  /// Get current answers
  Map<int, int> get answers => Map.unmodifiable(_answers);

  /// Get current question index
  int get currentQuestionIndex => _currentQuestionIndex;

  /// Get current question
  ISIQQuestion get currentQuestion => isiQuestions[_currentQuestionIndex];

  /// Get total questions
  int get totalQuestions => isiQuestions.length;

  /// Check if current question has been answered
  bool get isCurrentQuestionAnswered => _answers.containsKey(currentQuestion.id);

  /// Check if all questions are answered
  bool get isAllQuestionsAnswered => _answers.length == totalQuestions;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Get last detection result
  DetectionResult? get lastResult => _lastResult;

  /// Set answer for current question
  void setAnswer(int score) {
    _answers[currentQuestion.id] = score;
    notifyListeners();
  }

  /// Go to next question
  bool goToNextQuestion() {
    if (!isCurrentQuestionAnswered) {
      _errorMessage = 'Silakan pilih jawaban terlebih dahulu';
      notifyListeners();
      return false;
    }

    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      _errorMessage = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Go to previous question
  bool goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _errorMessage = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Jump to specific question
  void jumpToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  /// Calculate total score
  int get totalScore {
    return _answers.values.fold(0, (sum, score) => sum + score);
  }

  /// Get category based on total score
  ISICategory get category => ISICategory.fromScore(totalScore);

  /// Reset questionnaire
  void resetQuestionnaire() {
    _answers.clear();
    _currentQuestionIndex = 0;
    _errorMessage = null;
    _lastResult = null;
    notifyListeners();
  }

  /// Submit questionnaire and save to Firestore
  Future<bool> submitQuestionnaire(String userId) async {
    if (!isAllQuestionsAnswered) {
      _errorMessage = 'Harap jawab semua pertanyaan';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Convert answers map to ordered list
      List<int> answersList = [];
      for (var question in isiQuestions) {
        answersList.add(_answers[question.id] ?? 0);
      }

      // Create detection result
      final result = DetectionResult.fromAnswers(
        userId: userId,
        answers: answersList,
      );

      // Save to Firestore
      await _firestoreService.saveDetectionResult(result);

      _lastResult = result;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan hasil: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get progress percentage
  double get progress {
    if (totalQuestions == 0) return 0;
    return (_currentQuestionIndex + 1) / totalQuestions;
  }
}
