import '../models/main_list.dart';
import '../models/flashcard_model.dart';
import '../models/order_model.dart';
import '../models/quiz_model.dart';
import '../models/sub_name_item.dart';
import '../models/enum_target.dart';


/// بيانات الدروس
final Map<String, List<dynamic>> lessonData = {
  'capital': [
    QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'The capital of Iraq is ___ .',
      options: ['Baghdad','Karbala'],
      correctAnswer: 'Baghdad',
    ), QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'The capital of Pakistan is ___ .',
      options: ['Islamabad','New Delhi'],
      correctAnswer: 'Islamabad',
    ),

  ],

  //////////////////// Verb To Be //////////////////////////
  'present': [
    QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'I ___ Ali .',
      options: ['am','is','are'],
      correctAnswer: 'am',
    ), QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'He ___ a doctor .',
      options: ['am','is','are'],
      correctAnswer: 'is',
    ),

  ],'past': [
    QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'I ___ a student .',
      options: ['was','were'],
      correctAnswer: 'was',
    ), QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'Ali and I ___ in Istanbul .',
      options: ['was','were'],
      correctAnswer: 'were',
    ),

  ],'present negative': [
    QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'I ___ Ali .',
      options: ['am not',"isn't","aren't"],
      correctAnswer: 'am not',
    ), QuizModel(
      image: 'https://www.shutterstock.com/image-vector/broadcaster-news-reporting-live-pop-260nw-627076790.jpg',
      questionText: 'He ___ a doctor .',
      options: ['am not',"isn't","aren't"],
      correctAnswer: "isn't",
    ),

  ],
};
List<MainList> lessons = [
  MainList(
    name: 'Countries and Nationalities',
    subName: [
      SubNameItem(
        name: 'Capital',
        target: Target.quiz,
        data: lessonData['capital']!,
      ),
    ],
  ),
  MainList(
    name: 'Verb To Be',
    subName: [
      SubNameItem(
        name: 'present',
        target: Target.quiz,
        data: lessonData['present']!,
      ), SubNameItem(
        name: 'past',
        target: Target.quiz,
        data: lessonData['past']!,
      ),
    ],
  ),

];

