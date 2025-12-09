import 'package:flutter/foundation.dart';

import '../data/repositories/weather_repository.dart';
import '../models/weather_info.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel({required WeatherRepository repository}) : _repository = repository;

  final WeatherRepository _repository;

  WeatherInfo? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherInfo? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load({String city = 'Saint Petersburg'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _weather = await _repository.loadWeather(city: city);
    } catch (e) {
      _error = 'Ошибка загрузки погоды: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

