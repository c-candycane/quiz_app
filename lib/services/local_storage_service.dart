import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final instance = LocalStorageService._internal();
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<String> get scores => _prefs?.getStringList('scores') ?? [];

  Future<void> addScore(String s) async {
    final list = scores..add(s);
    await _prefs?.setStringList('scores', list);
  }

  Future<void> clearScores() async {
    await _prefs?.remove('scores');
  }
}
