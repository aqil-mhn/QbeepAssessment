import 'package:qbeep_assessment/configs/app.dart';
import 'package:qbeep_assessment/configs/app_config.dart';

void main() async {
  await AppConfig(
    appName: "QbeepAssessment",
    environment: AppEnvironment.development
  ).run();
}