import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const _notesKey = 'notes_storage';

  Future<void> saveNotes(List<Map<String, dynamic>> notes) async {
    final encoded = jsonEncode(notes);
    await _prefs.setString(_notesKey, encoded);
  }

  List<Map<String, dynamic>> readNotes() {
    final raw = _prefs.getString(_notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}


