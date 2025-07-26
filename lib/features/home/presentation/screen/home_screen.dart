import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindfulness_bell/core/constants/app_colors.dart';
import 'package:mindfulness_bell/core/constants/image_model.dart';
import 'package:mindfulness_bell/core/extension/responsive_size_extension.dart';
import 'package:mindfulness_bell/core/extension/sizedbox_extension.dart';
import 'package:mindfulness_bell/core/function/golbal_padding.dart';
import 'package:mindfulness_bell/core/widget/modified_text.dart';
import 'package:mindfulness_bell/features/home/presentation/provider/bell_name_provider.dart';
import 'package:mindfulness_bell/features/home/presentation/provider/image_map_provider.dart';
import 'package:mindfulness_bell/features/home/presentation/provider/mute_provider.dart';
import 'package:mindfulness_bell/features/home/presentation/provider/selected_bell_sound_provider.dart';
import 'package:mindfulness_bell/features/home/presentation/provider/time_interval_provider.dart';

import '../../data/service/notification_service.dart';
import '../widgets/bottom_row_button.dart';
import '../widgets/checkbox_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedBell = 'Singing Bowl';
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int repeatInterval = 5;
  bool muteInSilent = false;

  Future<void> pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        isStart ? startTime = picked : endTime = picked;
      });
    }
  }

  void onSave() async {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final selectedStart = startTime.hour * 60 + startTime.minute;

    if (selectedStart <= currentMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: PoppinsText(
            text: "Start time must be in the future",
            fontSize: 14,
          ),
        ),
      );
      return;
    }

    await NotificationService().scheduleBellNotifications(
      bell: selectedBell,
      start: startTime,
      end: endTime,
      intervalMinutes: repeatInterval,
      muteInSilent: ref.watch(muteProvider),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: PoppinsText(
          text: "Bell Scheduled",
          fontSize: 16,
        ),
      ),
    );
    await NotificationService().flutterLocalNotificationsPlugin.show(
          1,
          'Bell sceduled',
          'The bell sceduled success fully',
          NotificationDetails(
            android: AndroidNotificationDetails(
              sound: RawResourceAndroidNotificationSound(
                  ref.watch(selectedSoundProvider)),
              'bell_channel',
              'Bell Notifications',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: AppColors.scaffoldBGColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(ImageModel.scaffoldBgImage),
            ),
          ),
          padding: golbalPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // bell sound seletion row
              _bellSelectingRow(),
              context.customSizedBoxHgt(context, 40),
              const Center(
                child: MontserretText(
                  text: "Select a Sound For Your Mindfulness Bell",
                  fontSize: 11.1,
                  color: AppColors.textGrey,
                ),
              ),
              context.customSizedBoxHgt(context, 45),
              // first tile for select start time
              _timeTile(
                  "Starts in", startTime.format(context), () => pickTime(true)),
              // secound tile for select end time
              _timeTile(
                  "Ends in", endTime.format(context), () => pickTime(false)),
              // time selecting dropdown
              _dropdownTile("Repeat in", "$repeatInterval minutes", () {
                showRepeatDialog();
              }),
// checkbox tile
              CheckBoxTile(ref: ref),
              context.customSizedBoxHgt(context, 107),
              // bottom row button (cancel , save)
              BottomRowButton(onTap: onSave),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.scaffoldBGColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      title: const PoppinsText(
        text: "Mindfulness Bell",
        fontSize: 20,
        color: AppColors.white,
      ),
    );
  }

  Row _bellSelectingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ref.watch(bellNameProvider).map((bell) {
        final isSelected = selectedBell == bell;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedBell = bell;
            });
            if (selectedBell == 'Singing Bowl') {
              ref.read(selectedSoundProvider.notifier).state = 'singing_bowl';
            } else if (selectedBell == 'Ohm Bell') {
              ref.read(selectedSoundProvider.notifier).state = 'ohm_bell';
            } else if (selectedBell == "Gong") {
              ref.read(selectedSoundProvider.notifier).state = 'gong';
            } else {
              ref.read(selectedSoundProvider.notifier).state = 'singing_bowl';
            }
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(context.responsiveSize(6)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? Colors.purpleAccent : Colors.transparent,
                    width: context.responsiveSize(2),
                  ),
                ),
                child: CircleAvatar(
                  radius: context.responsiveSize(35),
                  backgroundImage:
                      AssetImage(ref.watch(imageMapProvider)[bell]!),
                  backgroundColor: Colors.transparent,
                ),
              ),
              context.customSizedBoxHgt(context, 5),
              MontserretText(
                text: bell,
                fontSize: 11.1,
                color: isSelected ? AppColors.white : AppColors.textGrey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _timeTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: MontserretText(
        text: title,
        fontSize: 15.1,
        color: AppColors.white,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MontserretText(
            text: value,
            fontSize: 15.1,
            color: AppColors.textGrey,
          ),
          context.customSizedBoxWdt(context, 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textGrey,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _dropdownTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      splashColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      title: MontserretText(
        text: title,
        fontSize: 11.1,
        color: AppColors.white,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MontserretText(
            text: value,
            fontSize: 11.1,
            color: AppColors.white,
          ),
          context.customSizedBoxWdt(context, 8),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.white),
        ],
      ),
      onTap: onTap,
    );
  }

  void showRepeatDialog() {
    // opening bottom sheet and select the time interval as user want
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ref.watch(timeIntervalProvider).map((min) {
          return ListTile(
            title: PoppinsText(
              text: "Time gap $min min",
              fontSize: 14,
              color: AppColors.white,
            ),
            onTap: () {
              setState(() {
                repeatInterval = min;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
