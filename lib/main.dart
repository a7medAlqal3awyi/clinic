import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/nutrition_app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Clean Architecture Service Locator & Local Storage
  await initServiceLocator();

  // Lock portrait orientation for consistent mobile experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NutritionApp());
}
