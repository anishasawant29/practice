import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'medicine.dart';

class StorageService {
  static const _key = "medicines";

  static Future<void> saveMedicines(List<Medicine> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = list.map((m) => m.toMap()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<List<Medicine>> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => Medicine.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}
