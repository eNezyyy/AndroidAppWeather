import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/weather_info.dart';

class WeatherApiService {
  WeatherApiService({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

  Future<WeatherInfo> fetchCurrentByCity(String city) async {
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
      throw Exception('Weather request failed: ${response.statusCode}');
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
  }
}


