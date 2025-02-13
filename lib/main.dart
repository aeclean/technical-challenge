// ignore_for_file: avoid_print

import "dart:async";

import "package:faithwave_app/src/di.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:faithwave_app/src/app.dart";
import "package:faithwave_app/src/build_args.dart";
import "package:faithwave_app/src/env.dart";

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await AppEnv.I.load(locale: AppEnvLocale.us);
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
      await setupDI();
      runApp(const App());
    },
    (error, stackTrace) {
      debugPrint("runZonedGuarded: Caught error in my root zone");
      debugPrint("runZonedGuarded: error: $error");
      debugPrint("runZonedGuarded: stackTrace: $stackTrace");
    },
  );
}
