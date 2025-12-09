import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/repositories/note_repository.dart';
import '../data/repositories/weather_repository.dart';
import '../models/note.dart';
import '../models/weather_info.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required NoteRepository noteRepository,
    required WeatherRepository weatherRepository,
    required String defaultCity,
  })  : _noteRepository = noteRepository,
        _weatherRepository = weatherRepository,
        _defaultCity = defaultCity;

  final NoteRepository _noteRepository;
  final WeatherRepository _weatherRepository;
  final String _defaultCity;

  final List<Note> _notes = [];
  WeatherInfo _weather = WeatherInfo.placeholder();
  bool _loadingNotes = true;
  bool _loadingWeather = true;
  String? _weatherError;

  List<Note> get notes => List.unmodifiable(_notes);
  WeatherInfo get weather => _weather;
  bool get loadingNotes => _loadingNotes;
  bool get loadingWeather => _loadingWeather;
  String? get weatherError => _weatherError;

  Future<void> init() async {
    await Future.wait([
      loadNotes(),
      loadWeather(),
    ]);
  }

  Future<void> loadNotes() async {
    _loadingNotes = true;
    notifyListeners();
    final loaded = await _noteRepository.loadNotes();
    _notes
      ..clear()
      ..addAll(loaded.isNotEmpty ? loaded : _seedNotes());
    if (loaded.isEmpty) {
      await _noteRepository.saveNotes(_notes);
    }
    _loadingNotes = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: _generateId(),
      title: title,
      content: content,
      date: _formatDate(DateTime.now()),
    );
    _notes.insert(0, note);
    notifyListeners();
    await _noteRepository.saveNotes(_notes);
  }

  Future<void> loadWeather() async {
    _loadingWeather = true;
    _weatherError = null;
    notifyListeners();
    try {
      _weather = await _weatherRepository.loadWeather(city: _defaultCity);
    } catch (e) {
      _weatherError = 'Не удалось загрузить погоду';
    } finally {
      _loadingWeather = false;
      notifyListeners();
    }
  }

  String _generateId() => Random().nextInt(1 << 32).toString();

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year}';
  }

  List<Note> _seedNotes() {
    return [
      Note(
        id: _generateId(),
        title: 'Список покупок',
        content: 'Молоко\nХлеб\nЯйца\nЯгоды',
        date: _formatDate(DateTime.now()),
      ),
      Note(
        id: _generateId(),
        title: 'Идея для проекта',
        content: 'Приложение с заметками и погодой.',
        date: _formatDate(DateTime.now().subtract(const Duration(days: 1))),
      ),
    ];
  }
}

