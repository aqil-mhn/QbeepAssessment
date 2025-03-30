import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qbeep_assessment/configs/app.dart';
import 'package:qbeep_assessment/configs/app_config.dart';
import 'package:qbeep_assessment/configs/database_config.dart';
import 'package:qbeep_assessment/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initiateDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await AppConfig(
    appName: "QbeepAssessment",
    environment: AppEnvironment.development
  ).run();
}