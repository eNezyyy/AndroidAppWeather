import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
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
  final List<Note> _notes = [
    Note(
      title: 'Список покупок',
      content: 'Молоко\nХлеб\nЯйца\nЯгоды',
      date: '08.12.2025',
    ),
    Note(
      title: 'Идея для проекта',
      content: 'Приложение с заметками и погодой.',
      date: '07.12.2025',
    ),
  ];

  void _addNote(Note note) {
    setState(() {
      _notes.insert(0, note);
      _currentIndex = 0; // возвращаемся на главную после добавления
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Заметка "${note.title}" добавлена'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openEditor() async {
    final createdNote = await Navigator.of(context).push<Note>(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          onSave: (note) => Navigator.of(context).pop(note),
        ),
      ),
    );
    if (createdNote != null) {
      _addNote(createdNote);
    }
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
    final pages = [
      HomeScreen(
        notes: _notes,
        onCreateNote: _openEditor,
        onOpenNote: _openDetails,
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


