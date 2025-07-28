import 'package:flutter/material.dart';
import 'package:mindfulness_bell/core/extension/responsive_size_extension.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/modified_text.dart';

class BottomRowButton extends StatelessWidget {
  const BottomRowButton({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.responsiveSize(30),
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: PoppinsText(
                text: "Cancel",
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saveButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.responsiveSize(30),
                ),
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: context.responsiveSize(14)),
              child: const PoppinsText(
                text: "Save",
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
