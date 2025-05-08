import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    if (quiz.questions.isEmpty) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    if (!_started) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<QuizProvider>().startQuiz();
      });
    }

    if (quiz.current >= quiz.questions.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/result');
      });
      return const SizedBox.shrink();
    }

    final question = quiz.questions[quiz.current];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Soru ${quiz.current + 1} / ${quiz.questions.length}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: kPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _TimerBar(
              label: 'Soru Süresi',
              progress: quiz.remainingQuestion.inSeconds /
                  quiz.perQuestion.inSeconds,
              seconds: quiz.remainingQuestion.inSeconds,
            ),
            const SizedBox(height: 8),
            _TimerBar(
              label: 'Toplam Süre',
              progress: quiz.remainingTotal.inSeconds /
                  ((quiz.perQuestion.inSeconds * quiz.questions.length)-20),
              seconds: quiz.remainingTotal.inSeconds,
            ),

            const SizedBox(height: 24),

            Card(
              color: kPrimary.withOpacity(.85),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.text,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const Spacer(),

            ...List.generate(question.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: kAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => quiz.answer(i),
                  child: Text(
                    question.options[i],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({
    required this.label,
    required this.progress,
    required this.seconds,
  });

  final String label;
  final double progress;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $seconds sn',
          style:
          const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(kAccent),
            ),
          ),
        ),
      ],
    );
  }
}
