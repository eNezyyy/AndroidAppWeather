import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

// Укажите ключ OpenWeatherMap перед использованием.
const String openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';

class WeatherService {
  Future<Weather> fetchCurrentByCity(String city) async {
    if (openWeatherApiKey == 'YOUR_OPENWEATHER_API_KEY') {
      // Чтобы не падать без ключа, возвращаем заглушку и подсказку.
      return const Weather(
        city: 'Ключ API не указан',
        temperature: 0,
        feelsLike: 0,
        description: 'Добавьте ключ OpenWeatherMap в weather_service.dart',
        icon: '50d',
      );
    }

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': city,
        'appid': openWeatherApiKey,
        'units': 'metric',
        'lang': 'ru',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
          'Не удалось получить погоду: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Weather.fromMap(data);
  }
}

