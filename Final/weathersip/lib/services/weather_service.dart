import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
  static const _base = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final uri = Uri.parse(_base).replace(queryParameters: {
      'latitude': '$lat',
      'longitude': '$lon',
      'current': 'temperature_2m,relative_humidity_2m,weather_code,uv_index',
      'timezone': 'auto',
    });

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        throw WeatherException('Gagal memuat cuaca (${res.statusCode})');
      }
      return WeatherModel.fromJson(jsonDecode(res.body));
    } on WeatherException {
      rethrow;
    } catch (_) {
      throw WeatherException('Periksa koneksi internet kamu');
    }
  }
}