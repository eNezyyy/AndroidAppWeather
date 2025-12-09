class Weather {
  const Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.icon,
  });

  final String city;
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      city: map['name'] as String? ?? '—',
      temperature: (map['main']?['temp'] as num?)?.toDouble() ?? 0,
      feelsLike: (map['main']?['feels_like'] as num?)?.toDouble() ?? 0,
      description: (map['weather'] is List && map['weather'].isNotEmpty)
          ? (map['weather'][0]['description'] as String? ?? '')
          : '',
      icon: (map['weather'] is List && map['weather'].isNotEmpty)
          ? (map['weather'][0]['icon'] as String? ?? '')
          : '',
    );
  }
}

