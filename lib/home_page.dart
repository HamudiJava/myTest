import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/views/first_page.dart';

class ButtonGlowEffect extends StatefulWidget {
  @override
  _ButtonGlowEffectState createState() => _ButtonGlowEffectState();
}

class _ButtonGlowEffectState extends State<ButtonGlowEffect> {
  // صور الأزرار الافتراضية وعند الضغط
  final List<String> defaultImages = [
    'assets/pink_default_one.png',
    'assets/pink_default_two.png',
    'assets/pink_default_three.png',
    'assets/pink_default_four.png',
  ];

  final List<String> pressedImages = [
    'assets/green_pressed_one.png',
    'assets/green_pressed_two.png',
    'assets/green_pressed_three.png',
    'assets/green_pressed_four.png',
  ];

  int? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('There are 4 levels'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             AnimatedContainer(
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(
                     color: Colors.white,
                     blurRadius: 20,
                   )
                 ]
               ),
               duration: Duration(seconds: 1),
               child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/boy_moon.png'),

                           ),
             ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 1, // المسافة بين الأعمدة
                mainAxisSpacing: 2, // المسافة بين الصفوف
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                String label = ['One', 'Two', 'Three', 'Four'][index];
                final isSelected = selectedItem == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = index;
                    });

                    // تغيير الصورة مؤقتًا
                    Future.delayed(const Duration(milliseconds: 200), () {
                      setState(() {
                        selectedItem = null; // عودة الحالة الافتراضية
                      });
                    });

                    // إذا كان الزر هو "One"، قم بالتنقل إلى الصفحة الأولى
                    if (label == 'One') {
                      Get.to(
                            () => FirstPage(),
                        transition: Transition.rightToLeft,
                        duration: Duration(seconds: 1),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        isSelected
                            ? pressedImages[index] // صورة الضغط الخاصة بالزر
                            : defaultImages[index], // الصورة الافتراضية الخاصة بالزر
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
