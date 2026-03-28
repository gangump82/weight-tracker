import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';

const _exerciseTypes = [
  ('running', '跑步 🏃', 10),
  ('swimming', '游泳 🏊', 8),
  ('cycling', '骑行 🚴', 7),
  ('gym', '健身 🏋️', 6),
  ('yoga', '瑜伽 🧘', 3),
  ('walking', '步行 🚶', 4),
  ('jumping', '跳绳 ⏫', 12),
  ('hiit', 'HIIT ⚡', 14),
];

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String _selectedType = 'running';
  final _durationController = TextEditingController();
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏃 运动记录'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Today Stats
                Card(
                  color: Colors.green.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '🏃 今日运动',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${provider.todayExerciseCalories}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text('消耗 kcal'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Add Exercise Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showAddDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text('记录运动'),
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
                          '📋 运动历史',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (provider.exercises.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('暂无运动记录'),
                            ),
                          )
                        else
                          ...provider.exercises.reversed.take(20).map(
                            (exercise) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Text(
                                exercise.typeIcon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(exercise.typeName),
                              subtitle: Text('${exercise.date} · ${exercise.duration}分钟'),
                              trailing: Text(
                                '${exercise.calories} kcal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
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
    _selectedType = 'running';
    _durationController.clear();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final selectedExercise = _exerciseTypes.firstWhere(
            (e) => e.$1 == _selectedType,
            orElse: () => _exerciseTypes[0],
          );
          final duration = int.tryParse(_durationController.text) ?? 0;
          final calories = duration * selectedExercise.$3;

          return AlertDialog(
            title: const Text('记录运动'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '日期',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _selectedDate),
                    onChanged: (v) => _selectedDate = v,
                  ),
                  const SizedBox(height: 12),
                  const Text('运动类型'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _exerciseTypes.map((type) {
                      final isSelected = _selectedType == type.$1;
                      return FilterChip(
                        label: Text(type.$2),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedType = type.$1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: '运动时长 (分钟)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  if (duration > 0) ...[
                    const SizedBox(height: 8),
                    Text('预计消耗: $calories kcal'),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: duration > 0
                    ? () {
                        provider.addExercise(ExerciseRecord(
                          date: _selectedDate,
                          type: selectedExercise.$1,
                          typeName: selectedExercise.$2.split(' ').first,
                          typeIcon: selectedExercise.$2.split(' ').last,
                          duration: duration,
                          calories: calories,
                        ));
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }
}
