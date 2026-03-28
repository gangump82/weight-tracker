import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 统计'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Comprehensive Stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 综合统计',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              '${provider.weightRecords.length}',
                              '记录天数',
                              Colors.purple,
                            ),
                            _buildStatItem(
                              '${provider.todayExerciseCalories}',
                              '今日消耗',
                              Colors.green,
                            ),
                            _buildStatItem(
                              '${provider.todayDietCalories}',
                              '今日摄入',
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Weight Progress
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚖️ 体重进度',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        if (provider.startWeight != null &&
                            provider.targetWeight != null &&
                            provider.currentWeight != null) ...[
                          LinearProgressIndicator(
                            value: _calculateProgress(provider),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '起始: ${provider.startWeight!.toStringAsFixed(1)}kg',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                '当前: ${provider.currentWeight!.toStringAsFixed(1)}kg',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                '目标: ${provider.targetWeight!.toStringAsFixed(1)}kg',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '完成度: ${(_calculateProgress(provider) * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ] else
                          const Text('请先设置目标体重'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Calorie Balance
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚖️ 今日热量平衡',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCalorieItem(
                              '${provider.todayDietCalories}',
                              '摄入',
                              Colors.orange,
                            ),
                            const Text('-', style: TextStyle(fontSize: 24)),
                            _buildCalorieItem(
                              '${provider.todayExerciseCalories}',
                              '消耗',
                              Colors.green,
                            ),
                            const Text('=', style: TextStyle(fontSize: 24)),
                            _buildCalorieItem(
                              '${provider.todayDietCalories - provider.todayExerciseCalories}',
                              '净热量',
                              provider.todayDietCalories > provider.todayExerciseCalories
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                          ],
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

  double _calculateProgress(AppProvider provider) {
    if (provider.startWeight == null ||
        provider.targetWeight == null ||
        provider.currentWeight == null) {
      return 0;
    }
    final totalToLose = provider.startWeight! - provider.targetWeight!;
    final lost = provider.startWeight! - provider.currentWeight!;
    if (totalToLose <= 0) return 0;
    return (lost / totalToLose).clamp(0.0, 1.0);
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCalorieItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
