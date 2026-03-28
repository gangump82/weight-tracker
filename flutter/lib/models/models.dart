class WeightRecord {
  final String date;
  final double weight;
  final DateTime createdAt;

  WeightRecord({
    required this.date,
    required this.weight,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'date': date,
    'weight': weight,
    'createdAt': createdAt.toIso8601String(),
  };

  factory WeightRecord.fromJson(Map<String, dynamic> json) => WeightRecord(
    date: json['date'],
    weight: json['weight'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class CheckIn {
  final String date;
  final DateTime createdAt;

  CheckIn({required this.date, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'date': date,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CheckIn.fromJson(Map<String, dynamic> json) => CheckIn(
    date: json['date'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class ExerciseRecord {
  final String id;
  final String date;
  final String type;
  final String typeName;
  final String typeIcon;
  final int duration;
  final int calories;
  final DateTime createdAt;

  ExerciseRecord({
    String? id,
    required this.date,
    required this.type,
    required this.typeName,
    required this.typeIcon,
    required this.duration,
    required this.calories,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'type': type,
    'typeName': typeName,
    'typeIcon': typeIcon,
    'duration': duration,
    'calories': calories,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) => ExerciseRecord(
    id: json['id'],
    date: json['date'],
    type: json['type'],
    typeName: json['typeName'],
    typeIcon: json['typeIcon'],
    duration: json['duration'],
    calories: json['calories'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class DietRecord {
  final String id;
  final String date;
  final String mealType;
  final String mealName;
  final String mealIcon;
  final int calories;
  final DateTime createdAt;

  DietRecord({
    String? id,
    required this.date,
    required this.mealType,
    required this.mealName,
    required this.mealIcon,
    required this.calories,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'mealType': mealType,
    'mealName': mealName,
    'mealIcon': mealIcon,
    'calories': calories,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DietRecord.fromJson(Map<String, dynamic> json) => DietRecord(
    id: json['id'],
    date: json['date'],
    mealType: json['mealType'],
    mealName: json['mealName'],
    mealIcon: json['mealIcon'],
    calories: json['calories'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class UserGoal {
  final double? targetWeight;
  final int? height;
  final int? age;
  final String? gender;

  UserGoal({this.targetWeight, this.height, this.age, this.gender});

  Map<String, dynamic> toJson() => {
    'targetWeight': targetWeight,
    'height': height,
    'age': age,
    'gender': gender,
  };

  factory UserGoal.fromJson(Map<String, dynamic> json) => UserGoal(
    targetWeight: json['targetWeight']?.toDouble(),
    height: json['height'],
    age: json['age'],
    gender: json['gender'],
  );
}

class Recipe {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;

  Recipe({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });
}

class DayMealPlan {
  final int dayIndex;
  final Recipe breakfast;
  final Recipe lunch;
  final Recipe dinner;
  final Recipe snack;

  DayMealPlan({
    required this.dayIndex,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snack,
  });

  int get totalCalories =>
      breakfast.calories + lunch.calories + dinner.calories + snack.calories;
}
