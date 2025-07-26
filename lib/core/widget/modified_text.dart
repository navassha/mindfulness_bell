import '../constants/app_fonts.dart';
import 'custom_textstyle.dart';

// montserretText
class MontserretText extends ModifiedText {
  const MontserretText({
    required super.text,
    required super.fontSize,
    super.fontWeight,
    super.color,
    super.fontfamily = AppFonts.montserrat,
    super.textAlign,
    super.overflow,
    super.key,
    super.maxLines,
    super.decoration,
  });
}

// poppins
class PoppinsText extends ModifiedText {
  const PoppinsText({
    required super.text,
    required super.fontSize,
    super.fontWeight,
    super.color,
    super.fontfamily = AppFonts.montserrat,
    super.textAlign,
    super.overflow,
    super.key,
    super.maxLines,
    super.decoration,
  });
}
