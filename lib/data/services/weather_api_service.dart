import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/weather_info.dart';

class WeatherApiService {
  WeatherApiService({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

  Future<WeatherInfo> fetchCurrentByCity(String city) async {
    // Если API ключ не установлен, возвращаем placeholder
    if (apiKey.isEmpty || apiKey == 'YOUR_API_KEY') {
      return WeatherInfo.placeholder();
    }

    try {
      final uri = Uri.https(
        'api.openweathermap.org',
        '/data/2.5/weather',
        <String, String>{
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'ru',
        },
      );

      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        // Если ошибка API, возвращаем placeholder вместо исключения
        return WeatherInfo.placeholder();
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final main = data['main'] as Map<String, dynamic>? ?? {};
      final weatherList = data['weather'] as List<dynamic>? ?? [];
      final weather = weatherList.isNotEmpty
          ? weatherList.first as Map<String, dynamic>
          : <String, dynamic>{};

      return WeatherInfo(
        city: data['name'] as String? ?? city,
        temperature: (main['temp'] as num?)?.toDouble() ?? 0,
        feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0,
        description: weather['description'] as String? ?? 'Нет данных',
        icon: weather['icon'] as String? ?? '01d',
      );
    } catch (e) {
      // При любой ошибке возвращаем placeholder
      return WeatherInfo.placeholder();
    }
  }
}

