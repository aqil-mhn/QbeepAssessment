import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:qbeep_assessment/configs/app_language.dart';
import 'package:qbeep_assessment/configs/app_nav.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qbeep_assessment/modules/home.dart';

class App extends StatefulWidget {
  App({
    super.key,
    required this.appName
  });

  String? appName;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final sessionStateStream = StreamController<SessionState>();
  NavigatorState get _navigator => NavKey.navKey.currentState!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 5)
    );
    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavKey.navKey,
        home: HomeScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        locale: Provider.of<AppLanguage>(context).appLocal,
        supportedLocales: [
          Locale('en'),
          Locale('my')
        ],
      ),
    );
  }
}