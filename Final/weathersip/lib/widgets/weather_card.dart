import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  IconData _iconFor(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 3) return Icons.cloud_outlined;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 95) return Icons.thunderstorm_outlined;
    if (code >= 51) return Icons.grain;
    return Icons.cloud_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: switch (provider.status) {
        WeatherStatus.loading => const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          ),
        WeatherStatus.error => Row(
            children: [
              const Icon(Icons.cloud_off, size: 38, color: AppColors.grey),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.read<WeatherProvider>().load(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        WeatherStatus.success => _buildSuccess(context, provider),
      },
    );
  }

  Widget _buildSuccess(BuildContext context, WeatherProvider provider) {
    final w = provider.weather!;
    final extra = provider.extraGoalMl;
    final recommended = provider.recommendedGoalMl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_iconFor(w.weatherCode), size: 38, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cuaca Hari Ini · Makassar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${w.temperature.toStringAsFixed(1)}°C · '
                    '${w.description} · Kelembapan ${w.humidity}%'
                    '${w.uvIndex != null ? ' · UV ${w.uvIndex!.toStringAsFixed(0)}' : ''}',
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          provider.hydrationTip,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.darkText,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                extra > 0
                    ? 'Rekomendasi target: $recommended ml (+$extra ml karena cuaca)'
                    : 'Rekomendasi target: $recommended ml',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<WaterProvider>().setDailyGoal(recommended);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Target harian diubah ke $recommended ml'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Terapkan'),
            ),
          ],
        ),
      ],
    );
  }
}