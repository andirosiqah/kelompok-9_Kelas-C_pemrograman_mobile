import 'package:flutter/foundation.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { loading, success, error }

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({WeatherService? service})
      : _service = service ?? WeatherService();

  final WeatherService _service;

  // Lokasi default: Makassar
  static const double _lat = -5.1477;
  static const double _lon = 119.4327;

  static const int baseGoalMl = 2000;

  WeatherStatus _status = WeatherStatus.loading;
  WeatherModel? _weather;
  String _errorMessage = '';

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;

  Future<void> load() async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _weather = await _service.fetchWeather(_lat, _lon);
      _status = WeatherStatus.success;
    } on WeatherException catch (e) {
      _errorMessage = e.message;
      _status = WeatherStatus.error;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat memuat cuaca';
      _status = WeatherStatus.error;
    }

    notifyListeners();
  }

  /// Tambahan target air (ml) berdasarkan suhu.
  int get extraGoalMl {
    final w = _weather;
    if (w == null) return 0;

    if (w.temperature >= 33) return 700;
    if (w.temperature >= 30) return 500;
    if (w.temperature >= 27) return 250;
    return 0;
  }

  int get recommendedGoalMl => baseGoalMl + extraGoalMl;

  /// Tips hidrasi singkat sesuai kondisi cuaca.
  String get hydrationTip {
    final w = _weather;
    if (w == null) return '';

    if (w.temperature >= 33) {
      return 'Cuaca sangat panas. Minum lebih sering dan hindari '
          'aktivitas berat di luar ruangan.';
    }
    if (w.temperature >= 30) {
      return 'Cuaca panas. Tambah asupan air agar tidak dehidrasi.';
    }
    if ((w.uvIndex ?? 0) >= 8) {
      return 'Indeks UV tinggi. Bawa botol minum jika beraktivitas di luar.';
    }
    if (w.weatherCode >= 51 && w.weatherCode <= 82) {
      return 'Sedang hujan. Udara sejuk bukan alasan untuk lupa minum.';
    }
    return 'Cuaca nyaman. Tetap minum air secara teratur sepanjang hari.';
  }
}