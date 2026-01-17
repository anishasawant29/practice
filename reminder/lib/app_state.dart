import 'package:flutter/material.dart';
import 'medicine.dart';

class AppState {
  static final ValueNotifier<List<Medicine>> medicines =
      ValueNotifier<List<Medicine>>([]);
}
