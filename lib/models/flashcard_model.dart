class FlashModel {
  final String image;
  final String audio;
  final String title;
  final String displayedText;

  FlashModel({
    required this.image,
    required this.audio,
    required this.title,
    required this.displayedText,
  });
  factory FlashModel.fromJson(Map<String, dynamic> json) {
    return FlashModel(
      image: json['image'] as String,
      audio: json['audio'] as String,
      title: json['title'] as String,
      displayedText: json['displayedText'] as String,
    );
  }




  // طريقة لتحويل FlashModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'audio': audio,
      'title': title,
      'displayedText': displayedText,
    };
  }
}