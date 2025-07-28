import 'package:flutter/material.dart';
import 'package:mindfulness_bell/core/extension/responsive_size_extension.dart';

//sizedbox with height and width
extension CustomSizedBox on BuildContext {
  SizedBox customSizedBoxHgt(BuildContext context, double height) =>
      SizedBox(height: context.responsiveSize(height));

  SizedBox customSizedBoxWdt(BuildContext context, double width) =>
      SizedBox(width: context.responsiveSize(width));
}
