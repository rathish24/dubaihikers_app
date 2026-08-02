import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation index provider for bottom navigation tab switching.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
