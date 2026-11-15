import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherTestScreen extends StatefulWidget {
  const WeatherTestScreen({super.key});

  @override
  State<WeatherTestScreen> createState() => _WeatherTestScreenState();
}

class _WeatherTestScreenState extends State<WeatherTestScreen> {
  late Future<WeatherModel> _future;

  @override
  void initState() {
    super.initState();
    // Koordinat Makassar sementara, lokasi asli ditambah di tahap berikutnya
    _future = WeatherService().fetchWeather(-5.1477, 119.4327);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tes Cuaca')),
      body: Center(
        child: FutureBuilder<WeatherModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final w = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${w.temperature} °C',
                    style: const TextStyle(fontSize: 48)),
                Text(w.description),
                Text('Kelembapan: ${w.humidity}%'),
              ],
            );
          },
        ),
      ),
    );
  }
}