import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../theme/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<String> _scores;

  @override
  void initState() {
    super.initState();
    _scores = LocalStorageService.instance.scores.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş Skorlar'),
         actions: [
          IconButton(
             onPressed: () {
               LocalStorageService.instance.clearScores();
               setState(() => _scores.clear());
             },
             icon: const Icon(Icons.delete_outline),
             tooltip: 'Tümünü Sil',
           )
         ],
      ),
      body: _scores.isEmpty
          ? const Center(child: Text('Henüz kayıtlı skor yok.'))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _scores.length,
        separatorBuilder: (_, __) =>
            Divider(color: Colors.white24, height: 20),
        itemBuilder: (context, index) {
          final raw = _scores[index];
          final parts = raw.split('–').map((e) => e.trim()).toList();
          final player = parts[0];
          final date   = parts.length > 1 ? parts[1] : '';
          final result = parts.length > 2 ? parts[2] : raw;

          return Card(
            color: kPrimary.withOpacity(.85),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: kAccent,
                child: Text('${index + 1}',
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(player,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('$date\n$result'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
