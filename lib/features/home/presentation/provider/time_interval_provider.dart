import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeIntervalProvider = StateProvider<List<int>>((ref) {
  return [3, 5, 10, 15];
});
