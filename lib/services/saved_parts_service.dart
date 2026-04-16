import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/part.dart';

class SavedPartsService {
  static const _key = 'saved_parts';

  static Future<List<Part>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => Part.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> isSaved(String partId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.any((e) => (jsonDecode(e) as Map)['id'].toString() == partId);
  }

  static Future<void> toggle(Part part) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    final index = list.indexWhere((e) => (jsonDecode(e) as Map)['id'].toString() == part.id);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.add(jsonEncode(part.toJson()));
    }
    await prefs.setStringList(_key, list);
  }

  static Future<void> remove(String partId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.removeWhere((e) => (jsonDecode(e) as Map)['id'].toString() == partId);
    await prefs.setStringList(_key, list);
  }
}
