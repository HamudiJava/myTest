class QuizOptionModel {
  final String? image;
  final String? audio;
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  // Constructor for QuizModel
  QuizOptionModel({
    this.image,
    this.audio,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  // Define the fromJson method to map JSON data to QuizModel
  factory QuizOptionModel.fromJson(Map<String, dynamic> json) {
    return QuizOptionModel(
      image: json['image'],
      audio: json['audio'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }

  // Optionally, you can add a toJson method if you need to send the model back to Firebase or another service
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'audio': audio,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}
