import 'goal_screen.dart';
import 'history_screen.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  void _addWater(int amount) {
  context.read<WaterProvider>().addWater(amount);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$amount ml berhasil ditambahkan!'),
      duration: const Duration(seconds: 1),
    ),
  );
}

Future<void> _showCustomAmountDialog(BuildContext context) async {
  final controller = TextEditingController();

  final amount = await showDialog<int>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Water Intake'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Water amount',
            hintText: 'Example: 300',
            suffixText: 'ml',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);

              if (value == null || value <= 0) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount.'),
                  ),
                );
                return;
              }

              Navigator.pop(dialogContext, value);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (amount != null && context.mounted) {
    context.read<WaterProvider>().addWater(amount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$amount ml added successfully!'),
      ),
    );
  }
}


  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Good morning!';
    } else if (hour < 15) {
      return 'Good afternoon!';
    } else if (hour < 18) {
      return 'Good evening!';
    } else {
      return 'Good evening!';
    }
  }

  String _getDate() {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    final now = DateTime.now();

    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();

    final int consumedMl = water.consumedMl;
    final int dailyGoalMl = water.dailyGoalMl;
    final double progress = water.progress;
    final int remaining = water.remainingMl;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDate(),
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Stay hydrated and healthy!',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  IconButton(
  tooltip: 'Water History',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.history,
    color: AppColors.primary,
    size: 30,
  ),
  style: IconButton.styleFrom(
    backgroundColor: AppColors.white,
    padding: const EdgeInsets.all(12),
  ),
),
                ],
              ),

              const SizedBox(height: 28),

              // DAILY PROGRESS CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Water Intake',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$consumedMl',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Text(
                            ' ml',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Text(
                            '/ $dailyGoalMl ml',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 11,
                        backgroundColor: Colors.white30,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}% completed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '$remaining ml to go',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoalScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Daily Goal'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ADD WATER SECTION
              const Text(
                'Add Your Water Intake',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'How much water did you drink?',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  _waterButton(150),
                  const SizedBox(width: 10),
                  _waterButton(250),
                  const SizedBox(width: 10),
                  _waterButton(500),
                ],
              ),
              
const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      _showCustomAmountDialog(context);
    },
    icon: const Icon(Icons.edit),
    label: const Text('Enter Custom Amount'),
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
),

              const SizedBox(height: 28),

              // WEATHER INFORMATION PLACEHOLDER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.cloud_outlined,
                      size: 38,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weather Today',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.darkText,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Weather information will appear here.',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MOTIVATION CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8F1EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💧 Hydration Tip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkText,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Keep drinking water regularly throughout '
                      'the day to help maintain your hydration.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WATER INTAKE BUTTON
  Widget _waterButton(int amount) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _addWater(amount),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFD5EAF0),
            ),
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.water_drop, size: 23),
            const SizedBox(height: 7),
            Text(
              '$amount ml',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
