import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for current selected tab index in bottom navigation bar.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
