import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  // Data
  List<WeightRecord> _weightRecords = [];
  List<CheckIn> _checkIns = [];
  List<ExerciseRecord> _exercises = [];
  List<DietRecord> _diets = [];
  UserGoal _userGoal = UserGoal();
  List<DayMealPlan> _mealPlans = [];

  // Getters
  List<WeightRecord> get weightRecords => _weightRecords;
  List<CheckIn> get checkIns => _checkIns;
  List<ExerciseRecord> get exercises => _exercises;
  List<DietRecord> get diets => _diets;
  UserGoal get userGoal => _userGoal;
  List<DayMealPlan> get mealPlans => _mealPlans;

  // Stats
  double? get currentWeight =>
      _weightRecords.isEmpty ? null : _weightRecords.last.weight;
  double? get startWeight =>
      _weightRecords.isEmpty ? null : _weightRecords.first.weight;
  double get weightLost {
    if (startWeight == null || currentWeight == null) return 0;
    return startWeight! - currentWeight!;
  }

  double? get bmi {
    if (currentWeight == null || _userGoal.height == null) return null;
    final heightM = _userGoal.height! / 100.0;
    return currentWeight! / (heightM * heightM);
  }

  int get streakDays {
    if (_checkIns.isEmpty) return 0;
    final sortedDates = _checkIns.map((c) => c.date).toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (int i = 0; i < sortedDates.length; i++) {
      final expectedDate = _formatDate(checkDate);
      if (sortedDates.contains(expectedDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  int get todayExerciseCalories {
    final today = _formatDate(DateTime.now());
    return _exercises
        .where((e) => e.date == today)
        .fold(0, (sum, e) => sum + e.calories);
  }

  int get todayDietCalories {
    final today = _formatDate(DateTime.now());
    return _diets
        .where((d) => d.date == today)
        .fold(0, (sum, d) => sum + d.calories);
  }

  bool get isCheckedInToday {
    final today = _formatDate(DateTime.now());
    return _checkIns.any((c) => c.date == today);
  }

  // Init
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load data
    final weightJson = prefs.getString('weight_records');
    if (weightJson != null) {
      final list = jsonDecode(weightJson) as List;
      _weightRecords = list.map((e) => WeightRecord.fromJson(e)).toList();
    }

    final checkInJson = prefs.getString('check_ins');
    if (checkInJson != null) {
      final list = jsonDecode(checkInJson) as List;
      _checkIns = list.map((e) => CheckIn.fromJson(e)).toList();
    }

    final exerciseJson = prefs.getString('exercises');
    if (exerciseJson != null) {
      final list = jsonDecode(exerciseJson) as List;
      _exercises = list.map((e) => ExerciseRecord.fromJson(e)).toList();
    }

    final dietJson = prefs.getString('diets');
    if (dietJson != null) {
      final list = jsonDecode(dietJson) as List;
      _diets = list.map((e) => DietRecord.fromJson(e)).toList();
    }

    final goalJson = prefs.getString('user_goal');
    if (goalJson != null) {
      _userGoal = UserGoal.fromJson(jsonDecode(goalJson));
    }

    notifyListeners();
  }

  // Save data
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weight_records', jsonEncode(_weightRecords.map((e) => e.toJson()).toList()));
    await prefs.setString('check_ins', jsonEncode(_checkIns.map((e) => e.toJson()).toList()));
    await prefs.setString('exercises', jsonEncode(_exercises.map((e) => e.toJson()).toList()));
    await prefs.setString('diets', jsonEncode(_diets.map((e) => e.toJson()).toList()));
    await prefs.setString('user_goal', jsonEncode(_userGoal.toJson()));
  }

  // Helper
  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  // Weight operations
  void addWeightRecord(String date, double weight) {
    _weightRecords.removeWhere((r) => r.date == date);
    _weightRecords.add(WeightRecord(date: date, weight: weight));
    _weightRecords.sort((a, b) => a.date.compareTo(b.date));
    _saveData();
    notifyListeners();
  }

  void deleteWeightRecord(String date) {
    _weightRecords.removeWhere((r) => r.date == date);
    _saveData();
    notifyListeners();
  }

  // Check-in operations
  void toggleCheckIn() {
    final today = _formatDate(DateTime.now());
    if (_checkIns.any((c) => c.date == today)) {
      _checkIns.removeWhere((c) => c.date == today);
    } else {
      _checkIns.add(CheckIn(date: today));
    }
    _saveData();
    notifyListeners();
  }

  // Exercise operations
  void addExercise(ExerciseRecord exercise) {
    _exercises.add(exercise);
    _saveData();
    notifyListeners();
  }

  void deleteExercise(String id) {
    _exercises.removeWhere((e) => e.id == id);
    _saveData();
    notifyListeners();
  }

  // Diet operations
  void addDiet(DietRecord diet) {
    _diets.add(diet);
    _saveData();
    notifyListeners();
  }

  void deleteDiet(String id) {
    _diets.removeWhere((d) => d.id == id);
    _saveData();
    notifyListeners();
  }

  // User goal
  void setUserGoal({double? targetWeight, int? height, int? age, String? gender}) {
    _userGoal = UserGoal(
      targetWeight: targetWeight ?? _userGoal.targetWeight,
      height: height ?? _userGoal.height,
      age: age ?? _userGoal.age,
      gender: gender ?? _userGoal.gender,
    );
    _saveData();
    notifyListeners();
  }

  // Meal plans
  void generateMealPlans() {
    final breakfastRecipes = [
      Recipe(name: '燕麦粥+鸡蛋+牛奶', calories: 380, protein: 18, carbs: 45, fat: 12, fiber: 5),
      Recipe(name: '全麦面包+煎蛋+酸奶', calories: 420, protein: 20, carbs: 48, fat: 15, fiber: 4),
      Recipe(name: '小米粥+肉包子+豆浆', calories: 450, protein: 18, carbs: 60, fat: 14, fiber: 3),
      Recipe(name: '鸡蛋灌饼+豆浆', calories: 480, protein: 16, carbs: 55, fat: 20, fiber: 2),
      Recipe(name: '杂粮馒头+鸡蛋+牛奶', calories: 400, protein: 18, carbs: 50, fat: 12, fiber: 6),
    ];

    final lunchRecipes = [
      Recipe(name: '米饭+清蒸鱼+炒青菜', calories: 550, protein: 28, carbs: 70, fat: 15, fiber: 5),
      Recipe(name: '米饭+红烧鸡块+炒西兰花', calories: 620, protein: 30, carbs: 75, fat: 20, fiber: 4),
      Recipe(name: '面条+番茄牛腩+青菜', calories: 600, protein: 25, carbs: 80, fat: 18, fiber: 4),
      Recipe(name: '杂粮饭+豆腐烧肉+炒时蔬', calories: 580, protein: 24, carbs: 72, fat: 18, fiber: 6),
      Recipe(name: '米饭+宫保鸡丁+凉拌黄瓜', calories: 560, protein: 26, carbs: 68, fat: 18, fiber: 3),
    ];

    final dinnerRecipes = [
      Recipe(name: '小米粥+清炒时蔬+煎饺', calories: 450, protein: 16, carbs: 58, fat: 16, fiber: 4),
      Recipe(name: '米饭+蒜蓉虾+炒豆苗', calories: 520, protein: 26, carbs: 65, fat: 15, fiber: 4),
      Recipe(name: '杂粮粥+肉末茄子+凉菜', calories: 480, protein: 18, carbs: 60, fat: 16, fiber: 5),
      Recipe(name: '馒头+冬瓜排骨汤+炒青菜', calories: 500, protein: 22, carbs: 62, fat: 16, fiber: 4),
      Recipe(name: '米饭+香菇滑鸡+炒西兰花', calories: 530, protein: 24, carbs: 65, fat: 17, fiber: 5),
    ];

    final snackRecipes = [
      Recipe(name: '苹果', calories: 95, protein: 0, carbs: 25, fat: 0, fiber: 4),
      Recipe(name: '酸奶', calories: 120, protein: 6, carbs: 15, fat: 4, fiber: 0),
      Recipe(name: '坚果一小把', calories: 150, protein: 5, carbs: 6, fat: 13, fiber: 2),
      Recipe(name: '香蕉', calories: 105, protein: 1, carbs: 27, fat: 0, fiber: 3),
      Recipe(name: '牛奶', calories: 150, protein: 8, carbs: 12, fat: 8, fiber: 0),
    ];

    final random = DateTime.now().millisecondsSinceEpoch;
    _mealPlans = List.generate(7, (index) {
      return DayMealPlan(
        dayIndex: index,
        breakfast: breakfastRecipes[(random + index) % breakfastRecipes.length],
        lunch: lunchRecipes[(random + index + 1) % lunchRecipes.length],
        dinner: dinnerRecipes[(random + index + 2) % dinnerRecipes.length],
        snack: snackRecipes[(random + index + 3) % snackRecipes.length],
      );
    });
    notifyListeners();
  }
}
