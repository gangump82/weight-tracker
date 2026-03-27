import SwiftUI

let EXERCISE_TYPES: [(type: String, name: String, icon: String, caloriesPerMin: Int)] = [
    ("running", "跑步", "🏃", 10),
    ("swimming", "游泳", "🏊", 8),
    ("cycling", "骑行", "🚴", 7),
    ("gym", "健身", "🏋️", 6),
    ("yoga", "瑜伽", "🧘", 3),
    ("walking", "步行", "🚶", 4),
    ("jumping", "跳绳", "⏫", 12),
    ("hiit", "HIIT", "⚡", 14)
]

struct ExerciseScreen: View {
    @ObservedObject var viewModel: WeightViewModel
    @State private var showAddSheet = false
    @State private var selectedType = EXERCISE_TYPES[0]
    @State private var duration = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Today Stats
                VStack(spacing: 12) {
                    HStack {
                        Text("🏃 今日运动")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.todayExerciseCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("消耗 kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                
                // Add Button
                Button(action: { showAddSheet = true }) {
                    Label("记录运动", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.green, .green.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                
                // Exercise History
                VStack(alignment: .leading, spacing: 8) {
                    Text("📋 运动历史")
                        .font(.headline)
                    
                    if viewModel.exercises.isEmpty {
                        Text("暂无运动记录")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(viewModel.exercises.suffix(20).reversed()) { exercise in
                            HStack {
                                Text(exercise.typeIcon)
                                    .font(.title)
                                
                                VStack(alignment: .leading) {
                                    Text(exercise.typeName)
                                        .font(.headline)
                                    Text("\(exercise.date) · \(exercise.duration)分钟")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(exercise.calories) kcal")
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
        .navigationTitle("🏃 运动记录")
        .sheet(isPresented: $showAddSheet) {
            AddExerciseSheet(
                viewModel: viewModel,
                selectedType: $selectedType,
                duration: $duration,
                selectedDate: $selectedDate
            )
        }
    }
}

struct AddExerciseSheet: View {
    @ObservedObject var viewModel: WeightViewModel
    @Binding var selectedType: (type: String, name: String, icon: String, caloriesPerMin: Int)
    @Binding var duration: String
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var calculatedCalories: Int {
        guard let mins = Int(duration) else { return 0 }
        return mins * selectedType.caloriesPerMin
    }
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("日期", selection: $selectedDate, displayedComponents: .date)
                
                Section("运动类型") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(EXERCISE_TYPES, id: \.type) { type in
                            Button(action: { selectedType = type }) {
                                VStack {
                                    Text(type.icon)
                                        .font(.title)
                                    Text(type.name)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(selectedType.type == type.type ? Color.purple.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                HStack {
                    Text("运动时长")
                    TextField("分钟", text: $duration)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("分钟")
                        .foregroundColor(.secondary)
                }
                
                if !duration.isEmpty {
                    HStack {
                        Text("预计消耗")
                        Spacer()
                        Text("\(calculatedCalories) kcal")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
            }
            .navigationTitle("记录运动")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        guard let mins = Int(duration), mins > 0 else { return }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        viewModel.addExercise(
                            date: dateFormatter.string(from: selectedDate),
                            type: selectedType.type,
                            typeName: selectedType.name,
                            typeIcon: selectedType.icon,
                            duration: mins,
                            calories: calculatedCalories
                        )
                        duration = ""
                        dismiss()
                    }
                    .disabled(duration.isEmpty)
                }
            }
        }
    }
}
