import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/order_model.dart';

bool toggleButton=false;



/// صفحة ترتيب الكلمات
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int currentIndex = 0;
  int correctScore = 0;
  int incorrectScore = 0;
  List<String> availableWords = [];
  List<String> arrangedWords = [];
  Set<String> crossedWords =
  {}; // Track words with grey and strikethrough effect

  @override
  void initState() {
    super.initState();
    initializeWords();
  }

  void initializeWords() {
    final arguments = Get.arguments;
    final List<dynamic> data = arguments['data'];
    final List<OrderModel> orderData =
    data.map((e) => e is OrderModel ? e : OrderModel.fromJson(e)).toList();

    final order = orderData[currentIndex];
    final correctWords = order.correctText.split(' ');
    final moreWords = order.moreWords.split(', ');

    availableWords = [...correctWords, ...moreWords];
    availableWords.shuffle();
    crossedWords.clear();
  }

  void goToNextQuestion(List<OrderModel> orderData) {
    setState(() {
      if (currentIndex < orderData.length - 1) {
        currentIndex++;
        arrangedWords.clear();
        crossedWords.clear();
        initializeWords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final List<dynamic> data = arguments['data'];
    final List<OrderModel> orderData =
    data.map((e) => e is OrderModel ? e : OrderModel.fromJson(e)).toList();

    final order = orderData[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Quiz'),
        elevation: 4,
        shadowColor: Colors.black,
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text("$incorrectScore",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text("$correctScore",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(order.quizText,
                  style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: arrangedWords.map((word) {
                  return Text(
                    word,
                    style: TextStyle(fontSize: 18),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 60),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
                color: Colors.cyan.withOpacity(0.2),
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableWords.map((word) {
                  final isCrossed = crossedWords.contains(word);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isCrossed) {
                          // Remove the word from arrangedWords and crossedWords only.
                          crossedWords.remove(word);
                          arrangedWords.remove(word);
                        } else {
                          // Add the word to arrangedWords and mark it as crossed.
                          crossedWords.add(word);
                          arrangedWords.add(word);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isCrossed ? Colors.grey : Colors.green),
                        borderRadius: BorderRadius.circular(8),
                        color: isCrossed?Colors.grey.withOpacity(0.20):Colors.yellow.withOpacity(0.5),

                      ),
                      child: Text(
                        word,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: isCrossed ? Colors.grey : Colors.black,
                          decoration:
                          isCrossed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  );

                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                if (arrangedWords.isNotEmpty) {
                  if(toggleButton=!toggleButton){
                    if (arrangedWords.join(' ') == order.correctText) {
                      setState(() {
                        correctScore++;
                      });
                    } else {
                      setState(() {
                        incorrectScore++;
                      });
                    }
                  }else{
                    goToNextQuestion(orderData);

                  }

                } else {
                  Get.snackbar(
                    'Warning!',
                    "You didn't choose any word yet",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}