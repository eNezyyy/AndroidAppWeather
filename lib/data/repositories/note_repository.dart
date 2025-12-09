import '../../models/note.dart';
import '../services/local_storage_service.dart';

class NoteRepository {
  NoteRepository(this._storage);

  final LocalStorageService _storage;

  Future<List<Note>> loadNotes() async {
    try {
      final items = _storage.readNotes();
      return items
          .map((item) {
            try {
              return Note.fromMap(item);
            } catch (_) {
              return null;
            }
          })
          .whereType<Note>()
          .where((note) => note.id.isNotEmpty && note.title.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    final mapped = notes.map((n) => n.toMap()).toList();
    await _storage.saveNotes(mapped);
  }
}

