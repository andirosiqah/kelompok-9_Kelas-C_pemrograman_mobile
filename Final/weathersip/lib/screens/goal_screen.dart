
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../theme/app_theme.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();

    final currentGoal =
        context.read<WaterProvider>().dailyGoalMl;

    _goalController = TextEditingController(
      text: currentGoal.toString(),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    final amount = int.tryParse(_goalController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid goal.'),
        ),
      );
      return;
    }

    context.read<WaterProvider>().setDailyGoal(amount);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily goal updated successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Goal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.flag_rounded,
              size: 65,
              color: AppColors.primary,
            ),

            const SizedBox(height: 20),

            const Text(
              'Set Your Daily Goal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Adjust your daily water intake target '
              'to help you stay hydrated.',
              style: TextStyle(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Daily Target (ml)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 2000',
                suffixText: 'ml',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Current goal: ${water.dailyGoalMl} ml',
              style: const TextStyle(
                color: AppColors.grey,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
