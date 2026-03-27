import Foundation
import SwiftUI

class WeightViewModel: ObservableObject {
    // Published properties
    @Published var weightRecords: [WeightRecord] = []
    @Published var checkIns: [CheckIn] = []
    @Published var exercises: [Exercise] = []
    @Published var diets: [Diet] = []
    @Published var userGoal: UserGoal = UserGoal()
    @Published var mealPlans: [DayMealPlan] = []
    
    // Stats
    @Published var currentWeight: Double?
    @Published var startWeight: Double?
    @Published var weightLost: Double = 0
    @Published var bmi: Double?
    @Published var streakDays: Int = 0
    @Published var todayExerciseCalories: Int = 0
    @Published var todayDietCalories: Int = 0
    
    // User defaults keys
    private let weightRecordsKey = "weight_records"
    private let checkInsKey = "check_ins"
    private let exercisesKey = "exercises"
    private let dietsKey = "diets"
    private let userGoalKey = "user_goal"
    private let mealPlansKey = "meal_plans"
    
    init() {
        loadData()
        calculateStats()
    }
    
    // MARK: - Data Persistence
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: weightRecordsKey),
           let records = try? JSONDecoder().decode([WeightRecord].self, from: data) {
            weightRecords = records.sorted { $0.date < $1.date }
        }
        
        if let data = UserDefaults.standard.data(forKey: checkInsKey),
           let items = try? JSONDecoder().decode([CheckIn].self, from: data) {
            checkIns = items
        }
        
        if let data = UserDefaults.standard.data(forKey: exercisesKey),
           let items = try? JSONDecoder().decode([Exercise].self, from: data) {
            exercises = items
        }
        
        if let data = UserDefaults.standard.data(forKey: dietsKey),
           let items = try? JSONDecoder().decode([Diet].self, from: data) {
            diets = items
        }
        
        if let data = UserDefaults.standard.data(forKey: userGoalKey),
           let goal = try? JSONDecoder().decode(UserGoal.self, from: data) {
            userGoal = goal
        }
        
        if let data = UserDefaults.standard.data(forKey: mealPlansKey),
           let plans = try? JSONDecoder().decode([DayMealPlan].self, from: data) {
            mealPlans = plans
        }
    }
    
    private func saveData() {
        if let data = try? JSONEncoder().encode(weightRecords) {
            UserDefaults.standard.set(data, forKey: weightRecordsKey)
        }
        if let data = try? JSONEncoder().encode(checkIns) {
            UserDefaults.standard.set(data, forKey: checkInsKey)
        }
        if let data = try? JSONEncoder().encode(exercises) {
            UserDefaults.standard.set(data, forKey: exercisesKey)
        }
        if let data = try? JSONEncoder().encode(diets) {
            UserDefaults.standard.set(data, forKey: dietsKey)
        }
        if let data = try? JSONEncoder().encode(userGoal) {
            UserDefaults.standard.set(data, forKey: userGoalKey)
        }
        if let data = try? JSONEncoder().encode(mealPlans) {
            UserDefaults.standard.set(data, forKey: mealPlansKey)
        }
    }
    
    // MARK: - Stats Calculation
    private func calculateStats() {
        if let first = weightRecords.first {
            startWeight = first.weight
        }
        if let last = weightRecords.last {
            currentWeight = last.weight
        }
        
        if let start = startWeight, let current = currentWeight {
            weightLost = start - current
        }
        
        if let height = userGoal.height, let weight = currentWeight {
            let heightM = Double(height) / 100.0
            bmi = weight / (heightM * heightM)
        }
        
        // Calculate streak
        let today = getToday()
        let sortedDates = checkIns.map { $0.date }.sorted(by: >)
        var streak = 0
        var checkDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        for _ in sortedDates {
            let dateStr = formatDate(checkDate)
            if sortedDates.contains(dateStr) {
                streak += 1
                checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        streakDays = streak
        
        // Today's stats
        todayExerciseCalories = exercises.filter { $0.date == today }.reduce(0) { $0 + $1.calories }
        todayDietCalories = diets.filter { $0.date == today }.reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Helper Functions
    func getToday() -> String {
        formatDate(Date())
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Weight Operations
    func addWeightRecord(date: String, weight: Double) {
        // Remove existing record for same date
        weightRecords.removeAll { $0.date == date }
        weightRecords.append(WeightRecord(date: date, weight: weight))
        weightRecords.sort { $0.date < $1.date }
        saveData()
        calculateStats()
    }
    
    func deleteWeightRecord(_ record: WeightRecord) {
        weightRecords.removeAll { $0.id == record.id }
        saveData()
        calculateStats()
    }
    
    // MARK: - Check-in Operations
    func toggleCheckIn() {
        let today = getToday()
        if let index = checkIns.firstIndex(where: { $0.date == today }) {
            checkIns.remove(at: index)
        } else {
            checkIns.append(CheckIn(date: today))
        }
        saveData()
        calculateStats()
    }
    
    func isCheckedInToday() -> Bool {
        checkIns.contains { $0.date == getToday() }
    }
    
    // MARK: - Exercise Operations
    func addExercise(date: String, type: String, typeName: String, typeIcon: String, duration: Int, calories: Int) {
        exercises.append(Exercise(date: date, type: type, typeName: typeName, typeIcon: typeIcon, duration: duration, calories: calories))
        saveData()
        calculateStats()
    }
    
    func deleteExercise(_ exercise: Exercise) {
        exercises.removeAll { $0.id == exercise.id }
        saveData()
        calculateStats()
    }
    
    // MARK: - Diet Operations
    func addDiet(date: String, mealType: String, mealName: String, mealIcon: String, foods: String, calories: Int) {
        diets.append(Diet(date: date, mealType: mealType, mealName: mealName, mealIcon: mealIcon, foods: foods, calories: calories))
        saveData()
        calculateStats()
    }
    
    func deleteDiet(_ diet: Diet) {
        diets.removeAll { $0.id == diet.id }
        saveData()
        calculateStats()
    }
    
    // MARK: - User Goal
    func setUserGoal(targetWeight: Double?, height: Int?, age: Int?, gender: String?) {
        userGoal.targetWeight = targetWeight
        userGoal.height = height
        userGoal.age = age
        userGoal.gender = gender
        saveData()
        calculateStats()
    }
    
    // MARK: - Meal Plan
    func generateMealPlan() {
        mealPlans = (0..<7).map { index in
            DayMealPlan(
                dayIndex: index,
                breakfast: breakfastRecipes.randomElement()!,
                lunch: lunchRecipes.randomElement()!,
                dinner: dinnerRecipes.randomElement()!,
                snack: snackRecipes.randomElement()!
            )
        }
        saveData()
    }
    
    // Recipe databases
    let breakfastRecipes: [Recipe] = [
        Recipe(name: "燕麦粥+鸡蛋+牛奶", calories: 380, protein: 18, carbs: 45, fat: 12, fiber: 5),
        Recipe(name: "全麦面包+煎蛋+酸奶", calories: 420, protein: 20, carbs: 48, fat: 15, fiber: 4),
        Recipe(name: "小米粥+肉包子+豆浆", calories: 450, protein: 18, carbs: 60, fat: 14, fiber: 3),
        Recipe(name: "鸡蛋灌饼+豆浆", calories: 480, protein: 16, carbs: 55, fat: 20, fiber: 2),
        Recipe(name: "杂粮馒头+鸡蛋+牛奶", calories: 400, protein: 18, carbs: 50, fat: 12, fiber: 6),
        Recipe(name: "蔬菜鸡蛋饼+小米粥", calories: 360, protein: 15, carbs: 42, fat: 14, fiber: 4),
        Recipe(name: "玉米+煮鸡蛋+豆浆", calories: 350, protein: 16, carbs: 40, fat: 12, fiber: 5)
    ]
    
    let lunchRecipes: [Recipe] = [
        Recipe(name: "米饭+清蒸鱼+炒青菜", calories: 550, protein: 28, carbs: 70, fat: 15, fiber: 5),
        Recipe(name: "米饭+红烧鸡块+炒西兰花", calories: 620, protein: 30, carbs: 75, fat: 20, fiber: 4),
        Recipe(name: "面条+番茄牛腩+青菜", calories: 600, protein: 25, carbs: 80, fat: 18, fiber: 4),
        Recipe(name: "杂粮饭+豆腐烧肉+炒时蔬", calories: 580, protein: 24, carbs: 72, fat: 18, fiber: 6),
        Recipe(name: "米饭+宫保鸡丁+凉拌黄瓜", calories: 560, protein: 26, carbs: 68, fat: 18, fiber: 3),
        Recipe(name: "糙米饭+清炒虾仁+炒芦笋", calories: 520, protein: 28, carbs: 65, fat: 14, fiber: 5),
        Recipe(name: "米饭+番茄炒蛋+清炒豆角", calories: 500, protein: 20, carbs: 70, fat: 15, fiber: 4)
    ]
    
    let dinnerRecipes: [Recipe] = [
        Recipe(name: "小米粥+清炒时蔬+煎饺", calories: 450, protein: 16, carbs: 58, fat: 16, fiber: 4),
        Recipe(name: "米饭+蒜蓉虾+炒豆苗", calories: 520, protein: 26, carbs: 65, fat: 15, fiber: 4),
        Recipe(name: "杂粮粥+肉末茄子+凉菜", calories: 480, protein: 18, carbs: 60, fat: 16, fiber: 5),
        Recipe(name: "馒头+冬瓜排骨汤+炒青菜", calories: 500, protein: 22, carbs: 62, fat: 16, fiber: 4),
        Recipe(name: "米饭+香菇滑鸡+炒西兰花", calories: 530, protein: 24, carbs: 65, fat: 17, fiber: 5),
        Recipe(name: "蔬菜汤面+卤蛋+小菜", calories: 420, protein: 18, carbs: 58, fat: 12, fiber: 4),
        Recipe(name: "红薯粥+清蒸蛋+凉拌黄瓜", calories: 380, protein: 14, carbs: 55, fat: 10, fiber: 4)
    ]
    
    let snackRecipes: [Recipe] = [
        Recipe(name: "苹果", calories: 95, protein: 0, carbs: 25, fat: 0, fiber: 4),
        Recipe(name: "酸奶", calories: 120, protein: 6, carbs: 15, fat: 4, fiber: 0),
        Recipe(name: "坚果一小把", calories: 150, protein: 5, carbs: 6, fat: 13, fiber: 2),
        Recipe(name: "香蕉", calories: 105, protein: 1, carbs: 27, fat: 0, fiber: 3),
        Recipe(name: "牛奶", calories: 150, protein: 8, carbs: 12, fat: 8, fiber: 0),
        Recipe(name: "橙子", calories: 65, protein: 1, carbs: 16, fat: 0, fiber: 3),
        Recipe(name: "全麦饼干+芝士", calories: 140, protein: 5, carbs: 15, fat: 7, fiber: 2)
    ]
}
