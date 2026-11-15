import '../models/water_intake.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/water_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
  }

int _getDailyTotal(
  List<WaterIntake> records,
  DateTime date,
) {
  return records
      .where((record) => _isSameDay(record.timestamp, date))
      .fold(0, (total, record) => total + record.amountMl);
}



  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();

    final records = water.intakes.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Water History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: records.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // SUMMARY CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Consumption",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '${water.consumedMl} ml',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${(water.progress * 100).toStringAsFixed(1)}% '
                          'of ${water.dailyGoalMl} ml daily goal',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: water.progress,
                            minHeight: 10,
                            backgroundColor: Colors.white30,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Consumption Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // HISTORY LIST
                  ...records.asMap().entries.map((entry) {
  final index = entry.key;
  final record = entry.value;

  final showDateHeader = index == 0 ||
      !_isSameDay(
        records[index - 1].timestamp,
        record.timestamp,
      );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showDateHeader) ...[
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(record.timestamp),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                '${_getDailyTotal(records, record.timestamp)} ml',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
                  Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Drank Water',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_formatDate(record.timestamp)} '
                                  '• ${_formatTime(record.timestamp)}',
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            '+${record.amountMl} ml',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

IconButton(
  tooltip: 'Edit record',
  icon: const Icon(
    Icons.edit_outlined,
    color: AppColors.primary,
    size: 21,
  ),
  onPressed: () {
    _showEditDialog(context, record);
  },
),


                          IconButton(
                            tooltip: 'Delete record',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 21,
                            ),
                            onPressed: () {
                              _showDeleteConfirmation(
                                context,
                                record.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 75,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Water Records Yet',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start tracking your water intake '
              'to see your history here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
void _showEditDialog(
  BuildContext context,
  WaterIntake record,
) {
  final controller = TextEditingController(
    text: record.amountMl.toString(),
  );

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Water Record'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Water amount',
            suffixText: 'ml',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              controller.dispose();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);

              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid amount.'),
                  ),
                );
                return;
              }

              context.read<WaterProvider>().updateWater(
                    record.id,
                    amount,
                  );

              Navigator.pop(dialogContext);
              controller.dispose();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Record updated successfully!'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

  void _showDeleteConfirmation(
    BuildContext context,
    String recordId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Record?'),
          content: const Text(
            'Are you sure you want to delete this water record?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<WaterProvider>().removeWater(recordId);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
