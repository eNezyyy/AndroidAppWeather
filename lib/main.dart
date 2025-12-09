import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'screens/main_navigation.dart';
import 'theme/app_theme.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // В release режиме логируем ошибку
        debugPrint('Flutter error: ${details.exception}');
      }
    };
    
    runApp(const MainApp());
  }, (error, stack) {
    // Обработка всех необработанных ошибок
    debugPrint('Unhandled error: $error');
    debugPrint('Stack: $stack');
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavigation(),
      builder: (context, child) {
        // Обработка ошибок рендеринга
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

