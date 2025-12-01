import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const _keyCrops = "cached_crops";
  static const _keyTimestamp = "cached_timestamp";

  Future<void> saveCrops(List<Map<String, dynamic>> crops) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(crops);
    await prefs.setString(_keyCrops, jsonString);
    await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Map<String, dynamic>>?> loadCrops() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyCrops);
    if (jsonString == null) return null;
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<int?> getLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTimestamp);
  }
}
