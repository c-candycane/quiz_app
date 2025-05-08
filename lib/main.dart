import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/services/local_storage_service.dart';
import 'package:quiz_app/theme/app_theme.dart';
import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.instance.init();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => QuizProvider()..loadQuestions(ctx),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: '/splash',
        routes: {
          '/splash': (ctx) => const SplashScreen(),
          '/': (ctx)      => const HomeScreen(),
          '/quiz': (ctx)  => const QuizScreen(),
          '/result': (ctx) => const ResultScreen(),
          '/history': (ctx) => const HistoryScreen(),
        },
      ),
    );
  }
}

