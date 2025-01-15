import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import '../models/quiz_model.dart';
import 'package:flutter/material.dart';

enum ButtonState { checkAnswer, nextQuestion }

class QuizController extends GetxController {
  var questionIndex = 0.obs;
  var correctScore = 0.obs;
  var wrongScore = 0.obs;
  var selectedOption = Rxn<String>();
  var buttonState = ButtonState.checkAnswer.obs;
  late AudioPlayer audioPlayer; // مشغل الصوتيات

  late List<QuizModel> questionsList;
  final AudioController audioController = Get.put(AudioController());


  @override
  void onInit() {
    super.onInit();
    // تهيئة مشغل الصوتيات
    audioPlayer = AudioPlayer();

    // استدعاء البيانات من arguments
    final arguments = Get.arguments;
    final List<dynamic> data = arguments['data'];
    questionsList =
        data.map((e) => e is QuizModel ? e : QuizModel.fromJson(e)).toList();

    questionsList.shuffle(); // خلط الأسئلة
    // تشغيل الصوت لأول مرة عند الدخول إلى الصفحة
    playAudioByIndex(questionIndex.value);
  }


  Future<void> playAudioByIndex(int index) async {
    try {
      final question = questionsList[index];
      if (question.audio != null && question.audio!.isNotEmpty) {
        // If the URL starts with gs://
        String audioUrl;
        // if (question.audio!.startsWith('gs://')) {
        // // Convert gs:// to a download URL
        //   final ref = FirebaseStorage.instance.refFromURL(question.audio!);
        //   audioUrl = await ref.getDownloadURL();
        // } else {
        // // If the URL is already direct
        //   audioUrl = question.audio!;
        // }
        audioUrl = question.audio!;


        // تشغيل الصوت
        await audioPlayer.stop(); // إيقاف أي صوت حالي
        await audioPlayer.setUrl(audioUrl); // تحميل رابط الصوت
        await audioPlayer.play(); // تشغيل الصوت
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }


  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == questionsList[questionIndex.value].correctAnswer) {
      correctScore.value++;
      audioController.playAudioByIndex(1);
    } else {
      wrongScore.value++;
      audioController.playAudioByIndex(2);
    }
    buttonState.value = ButtonState.nextQuestion;
  }

  void nextQuestion() {
    if (questionIndex.value < questionsList.length - 1) {
      questionIndex.value++;
      selectedOption.value = null;
      buttonState.value = ButtonState.checkAnswer;
      audioController.playAudioByIndex(0);

      playAudioByIndex(questionIndex.value);
    } else {
      showResultDialog();
    }
  }

  void resetQuiz() {
    questionIndex.value = 0;
    correctScore.value = 0;
    wrongScore.value = 0;
    selectedOption.value = null;
    buttonState.value = ButtonState.checkAnswer;
    questionsList.shuffle();
    audioController.playAudioByIndex(0);
// Play the audio for the first question

    playAudioByIndex(questionIndex.value);
  }

  void showResultDialog() {
    // تحديد رسالة النتيجة واللون بناءً على النتيجة
    String resultMessage = correctScore.value == questionsList.length
        ? "Congratulations! You passed."
        : "You failed. Try again.";

    Color backgroundColor = correctScore.value == questionsList.length
        ? Colors.green.shade300
        : Colors.red.shade300;

    String animationAsset = correctScore.value == questionsList.length
        ? 'assets/animations/success.json' // ملف Lottie عند النجاح
        : 'assets/animations/failure.json'; // ملف Lottie عند الفشل

    // تشغيل الصوت بناءً على النتيجة
    if (correctScore.value == questionsList.length) {
      audioController.playAudioByIndex(3); // صوت النجاح
    } else {
      audioController.playAudioByIndex(4); // صوت الفشل
    }

    // نافذة الحوار
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animation
              SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset(animationAsset,fit: BoxFit.fill), // ملف Lottie
              ),
              const SizedBox(height: 20),
              // رسالة النتيجة
              Text(
                "Quiz Result",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // زر التأكيد
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  resetQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  // Function to print the number of option items in the current question

  void printOptionsCount() {
    if (questionsList.isEmpty) {
      print("قائمة الأسئلة فارغة");
      return;
    }

    final question = questionsList[questionIndex.value];
    if (question.options.isEmpty) {
      print("خيارات السؤال فارغة");
      return;
    }

    final count = question.options.length;
    print("عدد الخيارات: $count");
  }


}


class QuizPage extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());
  final AudioController audioController = Get.put(AudioController());


  QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () => Text(
            "${controller.questionIndex.value + 1} / ${controller.questionsList.length}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
              audioController.playAudioByIndex(0);

            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () => Row(
                children: [
                  _buildScoreBox("${controller.wrongScore.value}", Colors.red),
                  const SizedBox(width: 4),
                  _buildScoreBox(
                      "${controller.correctScore.value}", Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // صورة السؤال
              Container(
                height: 200,
                padding: const EdgeInsets.all(4), // مسافة حول الصورة داخل الإطار
                decoration: BoxDecoration(
                  color: Colors.white, // لون الخلفية داخل الإطار

                ),
                child: Obx(
                      () {
                    final question =
                    controller.questionsList[controller.questionIndex.value];
                    return GestureDetector(
                      onTap: () {
                        controller.playAudioByIndex(controller.questionIndex.value);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5), // حواف دائرية للصورة فقط
                        child: Image.network(
                           question.image!,
                        ),
                      ),
                    );
                  },
                ),
              ),
          
              const SizedBox(height: 10),
              // عرض النص والسؤال
              Obx(() {
                final question =
                controller.questionsList[controller.questionIndex.value];
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                    children: _buildDynamicTextSpans(
                      question.questionText,
                      controller.buttonState.value ==
                          ButtonState.nextQuestion &&
                          controller.selectedOption.value ==
                              question.correctAnswer,
                      question.correctAnswer,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              // عرض الخيارات
              Obx(() {
                // تحديد الارتفاع بناءً على عدد العناصر في options
                double containerHeight = controller
                    .questionsList[controller.questionIndex.value].options.length == 2
                    ? 180.0
                    : 248.0;
                return Container(
                  width: double.infinity,
                  height: containerHeight,
          

                  child: ListView.builder(
                    itemCount: controller
                        .questionsList[controller.questionIndex.value].options.length,
                    itemBuilder: (context, index) {
                      final option = controller
                          .questionsList[controller.questionIndex.value].options[index];
          
                      return Obx(() {
                        final isSelected = controller.selectedOption.value == option;
                        final isCorrect =
                            option ==
                                controller
                                    .questionsList[controller.questionIndex.value]
                                    .correctAnswer;
                        print("Option at index $index: $option");
                        // تحديد لون الخلفية بناءً على حالة الخيار
                        Color? backgroundColor;
                        if (controller.buttonState.value == ButtonState.nextQuestion) {
                          backgroundColor = isCorrect
                              ? Colors.green[300]
                              : (isSelected ? Colors.red[300] : Colors.white);
                        } else {
                          backgroundColor =
                          isSelected ? Colors.orange[200] : Colors.white;
                        }
          
                        return GestureDetector(
                          onTap: controller.buttonState.value == ButtonState.checkAnswer
                              ? () {
                            controller.selectedOption.value = option;
                          }
                              : null,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.orange.shade300
                                    : Colors.grey.shade300,
                                width: 2,
                              ),

                            ),
                            child: Center(
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.orange.shade900
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
          
              },),
              const SizedBox(height: 16),
              // زر التحقق أو السؤال التالي
              Obx(
                    () => MaterialButton(
                  height: 50,
                  color: Colors.pink[300],

                  minWidth: double.infinity,
                  onPressed: controller.selectedOption.value == null
                      ? () {
                    Get.snackbar(
                      "Error",
                      "Please select an answer",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                      : () {
                    if (controller.buttonState.value ==
                        ButtonState.checkAnswer) {
                      controller
                          .checkAnswer(controller.selectedOption.value!);
                    } else {
                      controller.nextQuestion();
                    }
                  },
                  child: Text(
                    controller.buttonState.value == ButtonState.checkAnswer
                        ? "Check Answer"
                        : "Next Question",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildDynamicTextSpans(
      String questionText, bool isAnswerCorrect, String correctAnswer) {
    final parts = questionText.split("___");
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      spans.add(
        TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
      );
      if (i != parts.length - 1) {
        spans.add(
          TextSpan(
            text: isAnswerCorrect ? correctAnswer : "___",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isAnswerCorrect ? Colors.green : Colors.black,
            ),
          ),
        );
      }
    }

    return spans;
  }

  Widget _buildScoreBox(String score, Color color) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Center(
        child: Text(
          score,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}






class AudioController extends GetxController {
  late AudioPlayer audioPlayer;

  // قائمة مسارات الصوتيات من الـ assets
  final List<String> audioPaths = [
    'assets/audio/btn_sound4.mp3',
    'assets/audio/correct.mp3',
    'assets/audio/wrong_effect.wav',
    'assets/audio/excellent.mp3',
    'assets/audio/fail.mp3',
    // أضف المزيد من المسارات حسب الحاجة
  ];

  @override
  void onInit() {
    super.onInit();
    // تهيئة مشغل الصوتيات
    audioPlayer = AudioPlayer();
  }

  /// تشغيل الصوت باستخدام index
  Future<void> playAudioByIndex(int index) async {
    try {
      // تحقق من أن الـ index صالح
      if (index < 0 || index >= audioPaths.length) {
        print("Invalid index: $index");
        return;
      }

      // إيقاف الصوت الحالي
      await audioPlayer.stop();

      // تعيين ملف الصوت من القائمة بناءً على index
      await audioPlayer.setAsset(audioPaths[index]);

      // تشغيل الصوت
      await audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  /// إيقاف الصوت الحالي
  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  @override
  void onClose() {
    // تحرير الموارد عند الخروج
    audioPlayer.dispose();
    super.onClose();
  }
}
