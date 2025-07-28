import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindfulness_bell/core/extension/responsive_size_extension.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widget/modified_text.dart';
import '../provider/mute_provider.dart';

class CheckBoxTile extends StatelessWidget {
  const CheckBoxTile({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: ref.watch(muteProvider),
      onChanged: (val) {
        ref.read(muteProvider.notifier).state = val!;
      },
      title: const MontserretText(
        text: "Mute Bell in Silent Mode",
        fontSize: 14,
        color: AppColors.white,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.purpleAccent,
      checkboxShape: BeveledRectangleBorder(
        side: BorderSide(
          width: context.responsiveSize(0.1),
          color: AppColors.white,
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveSize(2),
        ),
      ),
    );
  }
}
