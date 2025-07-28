import 'package:flutter_riverpod/flutter_riverpod.dart';

final bellNameProvider = StateProvider<List<String>>((ref) {
  return ['Singing Bowl', 'Ohm Bell', 'Gong'];
});
