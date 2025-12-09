import 'package:flutter/foundation.dart';

import '../data/weather_service.dart';
import '../models/weather.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel({required WeatherService service}) : _service = service;

  final WeatherService _service;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load({String city = 'Saint Petersburg'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _weather = await _service.fetchCurrentByCity(city);
    } catch (e) {
      _error = 'Ошибка загрузки погоды: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


