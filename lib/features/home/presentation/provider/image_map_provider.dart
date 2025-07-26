import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindfulness_bell/core/constants/image_model.dart';

final imageMapProvider = StateProvider<Map<String, String>>((ref) {
  return {
    'Singing Bowl': ImageModel.singingBowl,
    'Ohm Bell': ImageModel.ohmBell,
    'Gong': ImageModel.gong,
  };
});
