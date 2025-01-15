import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/data.dart';
import '../models/main_list.dart';
import '../models/enum_target.dart';
import '../models/quiz_model.dart';
import '../widgets/textwidget.dart';

/// صفحة اختيار الدروس
class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose A Lesson'),
        elevation: 4,
        shadowColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<BaseController>(
                init: BaseController(),
                builder: (controller) {
                  return MaterialButton(
                    height: 100,
                    color: controller.isSelected(index) ? Colors.orange : null,
                    shape: const OutlineInputBorder(),
                    onPressed: () {
                      controller.updateIndex(index);
                      Get.toNamed('/gate', arguments: {
                        'lesson': lessons[index],
                      });
                    },
                    child: TextWidget(
                      text: lessons[index].name,
                      fontSize: 20,
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}

class BaseController extends GetxController {
  int? selectedItem;

  bool isSelected(int index) {
    return selectedItem == index;
  }

  void updateIndex(int index) {
    selectedItem = index;
    update(); // لتحديث الـ UI المرتبط بالـ Controller
  }
}

class GateController extends BaseController {
  void snackFun({required String title, required String text}) {
    Get.snackbar(title, text);
  }
}

/// صفحة البوابة
class Gate extends StatelessWidget {
  const Gate({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final lesson = arguments['lesson'] as MainList;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.name),
        elevation: 4,
        shadowColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: ListView.builder(
        itemCount: lesson.subName.length,
        itemBuilder: (context, index) {
          final subNameItem = lesson.subName[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<GateController>(
              init: GateController(),
              builder: (controller) {
                return MaterialButton(
                  height: 100,
                  shape: OutlineInputBorder(),
                  color: controller.isSelected(index) ? Colors.blue[200] : null,
                  onPressed: () {
                    controller.updateIndex(index);
                    switch (subNameItem.target) {
                      case Target.quiz:
                        Get.toNamed('/quiz',
                            arguments: {'data': subNameItem.data});
                        break;
                      case Target.orderWord:
                        Get.toNamed('/orderWord',
                            arguments: {'data': subNameItem.data});
                        break;
                      case Target.flash:
                        Get.toNamed(
                          '/flashcard',
                          arguments: {'data': subNameItem.data},
                        );
                        break;

                      case Target.optionQuiz:
                        // TODO: Handle this case.
                        throw UnimplementedError();
                    }
                  },
                  child: TextWidget(
                    text: subNameItem.name,
                    fontSize: 20,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
