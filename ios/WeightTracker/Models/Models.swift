import Foundation

struct WeightRecord: Identifiable, Codable {
    let id: UUID
    let date: String
    let weight: Double
    let createdAt: Date
    
    init(date: String, weight: Double) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.createdAt = Date()
    }
}

struct CheckIn: Identifiable, Codable {
    let id: UUID
    let date: String
    let createdAt: Date
    
    init(date: String) {
        self.id = UUID()
        self.date = date
        self.createdAt = Date()
    }
}

struct Exercise: Identifiable, Codable {
    let id: UUID
    let date: String
    let type: String
    let typeName: String
    let typeIcon: String
    let duration: Int
    let calories: Int
    let createdAt: Date
    
    init(date: String, type: String, typeName: String, typeIcon: String, duration: Int, calories: Int) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.typeName = typeName
        self.typeIcon = typeIcon
        self.duration = duration
        self.calories = calories
        self.createdAt = Date()
    }
}

struct Diet: Identifiable, Codable {
    let id: UUID
    let date: String
    let mealType: String
    let mealName: String
    let mealIcon: String
    let foods: String
    let calories: Int
    let createdAt: Date
    
    init(date: String, mealType: String, mealName: String, mealIcon: String, foods: String, calories: Int) {
        self.id = UUID()
        self.date = date
        self.mealType = mealType
        self.mealName = mealName
        self.mealIcon = mealIcon
        self.foods = foods
        self.calories = calories
        self.createdAt = Date()
    }
}

struct UserGoal: Codable {
    var targetWeight: Double?
    var height: Int?
    var age: Int?
    var gender: String?
}

struct Recipe: Codable {
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    let fiber: Int
}

struct DayMealPlan: Identifiable, Codable {
    let id: UUID
    let dayIndex: Int
    let breakfast: Recipe
    let lunch: Recipe
    let dinner: Recipe
    let snack: Recipe
    var totalCalories: Int {
        breakfast.calories + lunch.calories + dinner.calories + snack.calories
    }
    
    init(dayIndex: Int, breakfast: Recipe, lunch: Recipe, dinner: Recipe, snack: Recipe) {
        self.id = UUID()
        self.dayIndex = dayIndex
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.snack = snack
    }
}
