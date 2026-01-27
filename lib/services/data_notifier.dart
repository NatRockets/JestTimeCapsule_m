import 'package:flutter/foundation.dart';

/// Global notifier for data changes across the app
class DataNotifier {
  static final ValueNotifier<int> dataChanged = ValueNotifier<int>(0);

  /// Notify all listeners that data has changed
  static void notifyDataChanged() {
    dataChanged.value++;
  }
}
