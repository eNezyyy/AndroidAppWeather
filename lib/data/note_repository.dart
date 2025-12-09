import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteRepository {
  static const _storageKey = 'weather_notes_list';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    if (stored == null) return [];

    return stored
        .map((item) => Note.fromMap(jsonDecode(item) as Map<String, dynamic>))
        .where((note) => note.id.isNotEmpty)
        .toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = notes.map((n) => jsonEncode(n.toMap())).toList();
    await prefs.setStringList(_storageKey, payload);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}


