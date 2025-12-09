import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/note_repository.dart';
import '../data/repositories/weather_repository.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/weather_api_service.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../viewmodels/home_view_model.dart';
import 'home_screen.dart';
import 'note_detail_screen.dart';
import 'note_editor_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _ready = false;
  late HomeViewModel _viewModel;

  static const _apiKey = 'YOUR_API_KEY'; // замените на свой ключ OpenWeatherMap

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);
    final noteRepository = NoteRepository(storage);
    final weatherRepository =
        WeatherRepository(WeatherApiService(apiKey: _apiKey));

    _viewModel = HomeViewModel(
      noteRepository: noteRepository,
      weatherRepository: weatherRepository,
      defaultCity: 'Saint Petersburg',
    );
    _viewModel.addListener(_onVmChanged);
    await _viewModel.init();
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openEditor() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          onSave: (title, content) async {
            Navigator.of(context).pop();
            await _viewModel.addNote(title, content);
            if (mounted) {
              setState(() => _currentIndex = 0);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заметка "$title" добавлена'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _openDetails(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(
          title: note.title,
          content: note.content,
          date: note.date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = [
      HomeScreen(
        notes: _viewModel.notes,
        weather: _viewModel.weather,
        loadingWeather: _viewModel.loadingWeather,
        weatherError: _viewModel.weatherError,
        onCreateNote: _openEditor,
        onOpenNote: _openDetails,
        onRefreshWeather: _viewModel.loadWeather,
      ),
      SettingsScreen(
        onCreateNote: _openEditor,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.text.withOpacity(0.6),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

