import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/local_storage_service.dart';
import '../theme/colors.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final quiz        = context.read<QuizProvider>();
    final total       = quiz.questions.length;
    final correct     = quiz.correct;
    final percent     = correct / total;
    final percentText = (percent * 100).toStringAsFixed(1);
    final name        = quiz.playerName.isEmpty ? 'Anonim' : quiz.playerName;

    if (!_saved) {
      _saved = true;
      final when = DateFormat('dd.MM.yyyy  HH:mm').format(DateTime.now());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LocalStorageService.instance.addScore(
            '$name – $when – $correct / $total ($percentText%)');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sonuç'), centerTitle: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [kAccent.withOpacity(.15), Colors.transparent],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text('Tebrikler, $name!',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),

                const Spacer(),

                _ScoreCircle(
                  percent: percent,
                  label: '$correct / $total',
                  subLabel: '%$percentText doğru',
                ),

                const Spacer(),

                _ActionButtons(
                  onReplay: () {
                    quiz.reset();
                    Navigator.pushReplacementNamed(context, '/quiz');
                  },
                  onHome: () {
                    quiz.reset();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({
    required this.percent,
    required this.label,
    required this.subLabel,
  });

  final double percent; // 0–1
  final String label;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: percent.clamp(0.0, 1.0)),
      builder: (_, value, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(kAccent),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              label,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kAccent,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}


class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onReplay,
    required this.onHome,
  });

  final VoidCallback onReplay;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.replay),
          label: const Text('Tekrar Oyna'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: kAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: onReplay,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.home_outlined),
          label: const Text('Ana Sayfa'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            foregroundColor: kAccent,
            side: const BorderSide(color: kAccent),
          ),
          onPressed: onHome,
        ),
      ],
    );
  }
}
