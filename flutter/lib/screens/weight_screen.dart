import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚖️ 体重记录'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Check-in Card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 40)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${provider.streakDays}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('连续打卡'),
                              ],
                            ),
                          ],
                        ),
                        FilledButton(
                          onPressed: provider.toggleCheckIn,
                          style: FilledButton.styleFrom(
                            backgroundColor: provider.isCheckedInToday
                                ? Colors.green
                                : Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            provider.isCheckedInToday ? '✅ 已打卡' : '📅 今日打卡',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: '当前体重',
                        value: provider.currentWeight != null
                            ? '${provider.currentWeight!.toStringAsFixed(1)}kg'
                            : '--',
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: '目标体重',
                        value: provider.userGoal.targetWeight != null
                            ? '${provider.userGoal.targetWeight!.toStringAsFixed(1)}kg'
                            : '--',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: '已减重',
                        value: '${provider.weightLost.toStringAsFixed(1)}kg',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        title: 'BMI',
                        value: provider.bmi != null
                            ? provider.bmi!.toStringAsFixed(1)
                            : '--',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Add Weight Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showAddDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text('记录体重'),
                  ),
                ),
                const SizedBox(height: 16),

                // History
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📋 历史记录',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (provider.weightRecords.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('暂无记录'),
                            ),
                          )
                        else
                          ...provider.weightRecords.reversed.take(10).map(
                            (record) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('${record.weight.toStringAsFixed(1)}kg'),
                              trailing: Text(
                                record.date,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, AppProvider provider) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('记录体重'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: '日期',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: '体重 (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text);
              if (weight != null) {
                provider.addWeightRecord(dateController.text, weight);
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
