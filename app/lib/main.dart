import 'package:flutter/material.dart';
import 'package:app/core/di/injection.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDi();
  runApp(const QuickSlotApp());
}
