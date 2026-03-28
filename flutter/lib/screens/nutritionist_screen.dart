import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

const _days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

class NutritionistScreen extends StatefulWidget {
  const NutritionistScreen({super.key});

  @override
  State<NutritionistScreen> createState() => _NutritionistScreenState();
}

class _NutritionistScreenState extends State<NutritionistScreen> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👨‍⚕️ 营养师'),
        centerTitle: true,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Card(
                  color: Colors.green.withOpacity(0.1),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '👨‍⚕️ 顶级营养师',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('为您量身定制一周营养食谱'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Generate Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: provider.generateMealPlans,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('🧬 生成专属食谱'),
                  ),
                ),
                const SizedBox(height: 16),

                // Meal Plans
                if (provider.mealPlans.isNotEmpty) ...[
                  // Day Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(7, (index) {
                        final isSelected = _selectedDay == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_days[index]),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedDay = index),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Plan
                  if (_selectedDay < provider.mealPlans.length)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildMealRow('🌅 早餐', provider.mealPlans[_selectedDay].breakfast),
                            _buildMealRow('☀️ 午餐', provider.mealPlans[_selectedDay].lunch),
                            _buildMealRow('🌙 晚餐', provider.mealPlans[_selectedDay].dinner),
                            _buildMealRow('🍎 加餐', provider.mealPlans[_selectedDay].snack),
                            const Divider(),
                            Text(
                              '当日总计: ${provider.mealPlans[_selectedDay].totalCalories} kcal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealRow(String mealName, dynamic recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                recipe.name,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Text(
            '${recipe.calories} kcal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
