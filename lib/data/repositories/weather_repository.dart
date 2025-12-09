import '../../models/weather_info.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  WeatherRepository(this._apiService);

  final WeatherApiService _apiService;

  Future<WeatherInfo> loadWeather({required String city}) async {
    return _apiService.fetchCurrentByCity(city);
  }
}

