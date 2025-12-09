import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onCreateNote});

  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Профиль и настройки',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              title: const Text('Гость'),
              subtitle: const Text('Вход не требуется'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Подробнее'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: true,
            onChanged: (value) {},
            title: const Text('Уведомления'),
            subtitle: const Text('Получать напоминания о заметках'),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Цветовая схема'),
            subtitle: const Text('Основана на README'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Быстро создать заметку'),
            onTap: onCreateNote,
          ),
        ],
      ),
    );
  }
}


