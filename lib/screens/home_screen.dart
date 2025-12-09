import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/weather_info.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.notes,
    required this.weather,
    required this.loadingWeather,
    required this.weatherError,
    required this.onCreateNote,
    required this.onOpenNote,
    required this.onRefreshWeather,
  });

  final List<Note> notes;
  final WeatherInfo weather;
  final bool loadingWeather;
  final String? weatherError;
  final VoidCallback onCreateNote;
  final ValueChanged<Note> onOpenNote;
  final Future<void> Function() onRefreshWeather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Notes'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
        onPressed: onCreateNote,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Главный экран',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
              const SizedBox(height: 12),
              _WeatherCard(
                weather: weather,
                loading: loadingWeather,
                error: weatherError,
                onRefresh: onRefreshWeather,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Заметки',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.text,
                    ),
                  ),
                  Text(
                    '${notes.length} всего',
                    style: TextStyle(color: AppTheme.text.withOpacity(0.6)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _NoteCard(
                      title: note.title,
                      preview: note.content,
                      date: note.date,
                      onOpen: () => onOpenNote(note),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({
    required this.weather,
    required this.loading,
    required this.error,
    required this.onRefresh,
  });

  final WeatherInfo weather;
  final bool loading;
  final String? error;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF5FA7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  weather.city,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                onPressed: loading ? null : onRefresh,
                color: Colors.white,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (error != null)
            Text(
              error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(0)}°C, ${weather.description}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Ощущается как ${weather.feelsLike.toStringAsFixed(0)}°C',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.title,
    required this.preview,
    required this.date,
    required this.onOpen,
  });

  final String title;
  final String preview;
  final String date;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.text),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppTheme.text.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.text.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

