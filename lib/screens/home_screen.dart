import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Uygulaması'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Geçmiş Skorlar',
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: Center(
        child: quiz.questions.isEmpty
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow),
          label: const Text('Başla'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 16),
            textStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            final name = await _askName(context,
                defaultName: quiz.playerName);
            if (name != null && name.trim().isNotEmpty) {
              quiz.setPlayerName(name);
              quiz.reset();
              Navigator.pushNamed(context, '/quiz');
            }
          },
        ),
      ),
    );
  }

  Future<String?> _askName(BuildContext context,
      {String defaultName = ''}) {
    final controller = TextEditingController(text: defaultName);

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: kPrimary,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          cursorColor: kAccent,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Adınız',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kAccent, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final value = controller.text.trim();
              if (value.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('İsim boş olamaz.')),
                );
                return;
              }
              Navigator.pop(ctx, value);
            },
            child: const Text('Başla'),
          ),
        ],
      ),
    );
  }
}
