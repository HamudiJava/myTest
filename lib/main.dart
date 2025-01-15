import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:mytest/views/first_page.dart';
import 'package:mytest/views/orderword.dart';
import 'package:mytest/views/quiz.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true,elevation: 4),
      ),
      defaultTransition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 500),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>  ButtonGlowEffect()),
        GetPage(name: '/first_page', page: () =>  FirstPage()),
        GetPage(name: '/gate', page: () => const Gate()),
        GetPage(name: '/quiz', page: () =>  QuizPage()),
        GetPage(name: '/orderWord', page: () =>  OrderPage()),
        // GetPage(name: '/flashcard', page: () =>  FlashcardPage()),

      ],

    );
  }
}

// class FirstPage extends StatelessWidget {
//   const FirstPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('First Page'),
//       ),
//       body: ListView.builder(
//         itemCount: 3,
//         itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton(
//             onPressed: () {
//               Get.toNamed('second_page');
//             },
//             child: Text('Lesson $index'),
//           ),
//         );
//       },),
//     );
//   }
// }
//
// class SecondPage extends StatelessWidget {
//   const SecondPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(title: Text('Second Page'),
//       ),
//       body: ListView.builder(
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.toNamed('second_page');
//               },
//               child: Text('Lesson $index'),
//             ),
//           );
//         },),
//     );
//   }
// }
//
//
// class QuizPage extends StatelessWidget {
//   const QuizPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(title: Text('First Page'),
//       ),
//       body: ListView.builder(
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Get.toNamed('second_page');
//               },
//               child: Text('Lesson $index'),
//             ),
//           );
//         },),
//     );;
//   }
// }







