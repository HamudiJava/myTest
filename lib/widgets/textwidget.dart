import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final List<Shadow>? shadow;
  const TextWidget(
      {super.key,
      required this.text,
      this.textAlign,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.textDirection, this.shadow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadow,
      ),
    );
  }
}
