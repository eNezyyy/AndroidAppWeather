import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/note_repository.dart';
import '../models/note.dart';

class NotesViewModel extends ChangeNotifier {
  NotesViewModel({required NoteRepository repository})
      : _repository = repository;

  final NoteRepository _repository;

  final List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final stored = await _repository.loadNotes();
      if (stored.isEmpty) {
        _notes
          ..clear()
          ..addAll(_seedNotes);
        await _repository.saveNotes(_notes);
      } else {
        _notes
          ..clear()
          ..addAll(stored);
      }
    } catch (e) {
      _error = 'Не удалось загрузить заметки: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    final newNote = note.copyWith(id: _generateId());
    _notes.insert(0, newNote);
    notifyListeners();
    await _repository.saveNotes(_notes);
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _repository.saveNotes(_notes);
  }

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(9999).toString();

  List<Note> get _seedNotes => [
        Note(
          id: _generateId(),
          title: 'Список покупок',
          content: 'Молоко, хлеб, яйца, ягоды...',
          date: '08.12.2025',
        ),
        Note(
          id: _generateId(),
          title: 'Идея для проекта',
          content: 'Приложение с заметками и погодой',
          date: '07.12.2025',
        ),
      ];
}


