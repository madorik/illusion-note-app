class PsychologyTest {
  final String id;
  final String title;
  final String description;
  final String timeEstimate;
  final int questionCount;
  final bool isCompleted;
  final String? completedAt;
  final String? thumbnail;
  final bool isPremium;
  final List<PsychologyTestQuestion> questions;

  const PsychologyTest({
    required this.id,
    required this.title,
    required this.description,
    required this.timeEstimate,
    required this.questionCount,
    this.isCompleted = false,
    this.completedAt,
    this.thumbnail,
    this.isPremium = false,
    required this.questions,
  });
}

class PsychologyTestQuestion {
  final String id;
  final String question;
  final List<PsychologyTestOption> options;
  int? selectedOptionIndex;

  PsychologyTestQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.selectedOptionIndex,
  });
}

class PsychologyTestOption {
  final String id;
  final String text;
  final int score;

  const PsychologyTestOption({
    required this.id,
    required this.text,
    required this.score,
  });
}

class PsychologyTestResult {
  final String testId;
  final String resultType;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> characteristics;
  final List<String> strengths;
  final List<String> weaknesses;
  final DateTime completedAt;

  const PsychologyTestResult({
    required this.testId,
    required this.resultType,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.characteristics,
    required this.strengths,
    required this.weaknesses,
    required this.completedAt,
  });
} 