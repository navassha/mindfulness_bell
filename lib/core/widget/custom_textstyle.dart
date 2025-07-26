import 'package:flutter/material.dart';
import 'package:mindfulness_bell/core/extension/responsive_size_extension.dart';

//Base TextStyle format
class ModifiedText extends StatelessWidget {
  const ModifiedText(
      {required this.text,
      required this.fontSize,
      this.fontfamily,
      this.maxLines,
      this.decoration,
      this.color,
      this.fontWeight,
      this.textAlign,
      super.key,
      this.overflow});
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontfamily;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
        decoration: decoration,
        overflow: overflow,
        fontSize: context.responsiveSize(fontSize),
        fontFamily: fontfamily,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
