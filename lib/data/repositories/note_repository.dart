import '../../models/note.dart';
import '../services/local_storage_service.dart';

class NoteRepository {
  NoteRepository(this._storage);

  final LocalStorageService _storage;

  Future<List<Note>> loadNotes() async {
    final items = _storage.readNotes();
    return items.map(Note.fromMap).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final mapped = notes.map((n) => n.toMap()).toList();
    await _storage.saveNotes(mapped);
  }
}


