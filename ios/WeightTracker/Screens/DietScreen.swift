import SwiftUI

let MEAL_TYPES: [(type: String, name: String, icon: String)] = [
    ("breakfast", "早餐", "🌅"),
    ("lunch", "午餐", "☀️"),
    ("dinner", "晚餐", "🌙"),
    ("snack", "加餐", "🍎")
]

struct DietScreen: View {
    @ObservedObject var viewModel: WeightViewModel
    @State private var showAddSheet = false
    @State private var selectedMealType = MEAL_TYPES[0]
    @State private var foodName = ""
    @State private var calories = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Today Stats
                VStack(spacing: 12) {
                    HStack {
                        Text("🥗 今日饮食")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.todayDietCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("摄入 kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Add Button
                Button(action: { showAddSheet = true }) {
                    Label("记录饮食", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.orange, .orange.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                
                // Diet History
                VStack(alignment: .leading, spacing: 8) {
                    Text("📋 饮食历史")
                        .font(.headline)
                    
                    if viewModel.diets.isEmpty {
                        Text("暂无饮食记录")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(viewModel.diets.suffix(20).reversed()) { diet in
                            HStack {
                                Text(diet.mealIcon)
                                    .font(.title)
                                
                                VStack(alignment: .leading) {
                                    Text(diet.mealName)
                                        .font(.headline)
                                    Text(diet.date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(diet.calories) kcal")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 8)
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("🥗 饮食记录")
        .sheet(isPresented: $showAddSheet) {
            AddDietSheet(
                viewModel: viewModel,
                selectedMealType: $selectedMealType,
                foodName: $foodName,
                calories: $calories,
                selectedDate: $selectedDate
            )
        }
    }
}

struct AddDietSheet: View {
    @ObservedObject var viewModel: WeightViewModel
    @Binding var selectedMealType: (type: String, name: String, icon: String)
    @Binding var foodName: String
    @Binding var calories: String
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("日期", selection: $selectedDate, displayedComponents: .date)
                
                Section("餐次") {
                    HStack(spacing: 8) {
                        ForEach(MEAL_TYPES, id: \.type) { meal in
                            Button(action: { selectedMealType = meal }) {
                                VStack {
                                    Text(meal.icon)
                                        .font(.title2)
                                    Text(meal.name)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(selectedMealType.type == meal.type ? Color.orange.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                HStack {
                    Text("食物名称")
                    TextField("例如: 米饭", text: $foodName)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("热量")
                    TextField("kcal", text: $calories)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("kcal")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("记录饮食")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        guard let cals = Int(calories), cals > 0 else { return }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        viewModel.addDiet(
                            date: dateFormatter.string(from: selectedDate),
                            mealType: selectedMealType.type,
                            mealName: foodName.isEmpty ? selectedMealType.name : foodName,
                            mealIcon: selectedMealType.icon,
                            foods: foodName,
                            calories: cals
                        )
                        foodName = ""
                        calories = ""
                        dismiss()
                    }
                    .disabled(calories.isEmpty)
                }
            }
        }
    }
}
