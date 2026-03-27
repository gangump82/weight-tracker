import SwiftUI

let PEOPLE_TYPES: [(name: String, type: String)] = [
    ("👶 婴儿(6-12月)", "baby"),
    ("🧒 幼儿(1-3岁)", "toddler"),
    ("👦 儿童(4-12岁)", "child"),
    ("🤰 孕妇", "pregnant"),
    ("🤱 哺乳期", "lactating"),
    ("💪 健身人士", "fitness"),
    ("🏋️ 增肌人群", "muscle_gain"),
    ("👴 中老年人", "elderly"),
    ("🧓 养生保健", "senior_health"),
    ("🧘 减脂人群", "weight_loss"),
    ("🩺 糖尿病", "diabetic"),
    ("📚 学生党", "student")
]

struct NutritionistScreen: View {
    @ObservedObject var viewModel: WeightViewModel
    @State private var selectedPeopleType = "weight_loss"
    @State private var selectedDay = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Text("👨‍⚕️ 顶级营养师")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Text("基于您的身体状况和目标，为您量身定制一周营养食谱")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // People Type Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("选择人群类型")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(PEOPLE_TYPES, id: \.type) { item in
                            Button(action: { selectedPeopleType = item.type }) {
                                Text(item.name)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(selectedPeopleType == item.type ? Color.green.opacity(0.2) : Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
                
                // Generate Button
                Button(action: { viewModel.generateMealPlan() }) {
                    Label("🧬 生成专属食谱", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.green, .teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                
                // Meal Plan
                if !viewModel.mealPlans.isEmpty {
                    // Day Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["周一", "周二", "周三", "周四", "周五", "周六", "周日"].indices, id: \.self) { index in
                                Button(action: { selectedDay = index }) {
                                    Text(["周一", "周二", "周三", "周四", "周五", "周六", "周日"][index])
                                        .font(.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedDay == index ? Color.purple : Color(.systemGray5))
                                        .foregroundColor(selectedDay == index ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Daily Plan
                    if selectedDay < viewModel.mealPlans.count {
                        let day = viewModel.mealPlans[selectedDay]
                        
                        VStack(spacing: 12) {
                            ForEach([
                                ("🌅 早餐", day.breakfast),
                                ("☀️ 午餐", day.lunch),
                                ("🌙 晚餐", day.dinner),
                                ("🍎 加餐", day.snack)
                            ], id: \.0) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.0)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                        Text(item.1.name)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(item.1.calories) kcal")
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("当日总计")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(day.totalCalories) kcal")
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                            }
                            .padding()
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("👨‍⚕️ 营养师")
    }
}
