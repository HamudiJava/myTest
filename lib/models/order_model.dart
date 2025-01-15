// نموذج بيانات OrderModel
class OrderModel {
  final String? image;
  final String quizText;
  final String correctText;
  final String moreWords;

  OrderModel({
    this.image,
    required this.quizText,
    required this.correctText,
    required this.moreWords,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      quizText: json['quizText'],
      image: json['image'],
      correctText: json['correctText'],
      moreWords: json['moreWords'],
    );
  }
}