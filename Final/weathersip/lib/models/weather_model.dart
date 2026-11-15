class WeatherModel {
  final double temperature; // °C
  final int humidity; // %
  final int weatherCode; // kode cuaca WMO
  final double? uvIndex;

  const WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
    this.uvIndex,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    return WeatherModel(
      temperature: (c['temperature_2m'] as num).toDouble(),
      humidity: (c['relative_humidity_2m'] as num).toInt(),
      weatherCode: (c['weather_code'] as num).toInt(),
      uvIndex: (c['uv_index'] as num?)?.toDouble(),
    );
  }

  String get description => switch (weatherCode) {
        0 => 'Cerah',
        1 || 2 || 3 => 'Berawan',
        45 || 48 => 'Berkabut',
        >= 51 && <= 67 => 'Hujan',
        >= 80 && <= 82 => 'Hujan lebat',
        >= 95 => 'Badai petir',
        _ => 'Tidak diketahui',
      };
}