import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';

const _mealTypes = [
  ('breakfast', '早餐 🌅'),
  ('lunch', '午餐 ☀️'),
  ('dinner', '晚餐 🌙'),
  ('snack', '加餐 🍎'),
];

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  String _selectedMealType = 'breakfast';
  final _foodController = TextEditingController();
  final _caloriesController = TextEditingController();
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _foodController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🥗 饮食记录'),
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
                  color: Colors.orange.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '🥗 今日饮食',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${provider.todayDietCalories}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text('摄入 kcal'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Add Diet Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showAddDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text('记录饮食'),
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
                          '📋 饮食历史',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (provider.diets.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('暂无饮食记录'),
                            ),
                          )
                        else
                          ...provider.diets.reversed.take(20).map(
                            (diet) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Text(
                                diet.mealIcon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(diet.mealName),
                              subtitle: Text(diet.date),
                              trailing: Text(
                                '${diet.calories} kcal',
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
    _selectedMealType = 'breakfast';
    _foodController.clear();
    _caloriesController.clear();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('记录饮食'),
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
                  const Text('餐次'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _mealTypes.map((type) {
                      final isSelected = _selectedMealType == type.$1;
                      return FilterChip(
                        label: Text(type.$2),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedMealType = type.$1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _foodController,
                    decoration: const InputDecoration(
                      labelText: '食物名称',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(
                      labelText: '热量 (kcal)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () {
                  final calories = int.tryParse(_caloriesController.text) ?? 0;
                  if (calories > 0) {
                    final mealInfo = _mealTypes.firstWhere(
                      (t) => t.$1 == _selectedMealType,
                      orElse: () => _mealTypes[0],
                    );
                    provider.addDiet(DietRecord(
                      date: _selectedDate,
                      mealType: _selectedMealType,
                      mealName: _foodController.text.isEmpty
                          ? mealInfo.$2.split(' ').first
                          : _foodController.text,
                      mealIcon: mealInfo.$2.split(' ').last,
                      calories: calories,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }
}
