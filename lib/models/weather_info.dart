class WeatherInfo {
  WeatherInfo({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.icon,
  });

  final String city;
  final double temperature;
  final double feelsLike;
  final String description;
  final String icon;

  factory WeatherInfo.placeholder() => WeatherInfo(
        city: 'Санкт-Петербург',
        temperature: 22,
        feelsLike: 21,
        description: 'Облачно',
        icon: '03d',
      );
}


