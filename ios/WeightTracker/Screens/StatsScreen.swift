import SwiftUI

struct StatsScreen: View {
    @ObservedObject var viewModel: WeightViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Comprehensive Stats
                VStack(spacing: 12) {
                    HStack {
                        Text("📊 综合统计")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.weightRecords.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            Text("记录天数")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(viewModel.todayExerciseCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("今日消耗")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(viewModel.todayDietCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("今日摄入")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
                
                // Weight Progress
                VStack(spacing: 12) {
                    HStack {
                        Text("⚖️ 体重进度")
                            .font(.headline)
                        Spacer()
                    }
                    
                    if viewModel.startWeight != nil && viewModel.userGoal.targetWeight != nil {
                        let progress = calculateProgress()
                        
                        VStack(spacing: 8) {
                            ProgressView(value: progress)
                                .tint(.purple)
                            
                            HStack {
                                Text("起始: \(String(format: "%.1f", viewModel.startWeight!))kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("当前: \(String(format: "%.1f", viewModel.currentWeight ?? 0))kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("目标: \(String(format: "%.1f", viewModel.userGoal.targetWeight!))kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("完成度: \(Int(progress * 100))%")
                                .font(.headline)
                                .foregroundColor(.purple)
                        }
                    } else {
                        Text("请先设置目标体重")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
                
                // Calorie Balance
                VStack(spacing: 12) {
                    HStack {
                        Text("⚖️ 今日热量平衡")
                            .font(.headline)
                        Spacer()
                    }
                    
                    let netCalories = viewModel.todayDietCalories - viewModel.todayExerciseCalories
                    
                    HStack {
                        VStack {
                            Text("\(viewModel.todayDietCalories)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("摄入")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("-")
                            .font(.title)
                        
                        VStack {
                            Text("\(viewModel.todayExerciseCalories)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("消耗")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("=")
                            .font(.title)
                        
                        VStack {
                            Text("\(netCalories)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(netCalories > 0 ? .red : .blue)
                            Text("净热量")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
                
                // Week Summary
                VStack(spacing: 12) {
                    HStack {
                        Text("📅 本周统计")
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        VStack {
                            let weekExercises = viewModel.exercises.filter { isThisWeek($0.date) }
                            Text("\(weekExercises.count)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            Text("运动次数")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            let weekCalories = viewModel.exercises.filter { isThisWeek($0.date) }.reduce(0) { $0 + $1.calories }
                            Text("\(weekCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text("消耗 kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            let weekDietCalories = viewModel.diets.filter { isThisWeek($0.date) }.reduce(0) { $0 + $1.calories }
                            Text("\(weekDietCalories)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            Text("摄入 kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("📊 统计")
    }
    
    private func calculateProgress() -> Double {
        guard let start = viewModel.startWeight,
              let target = viewModel.userGoal.targetWeight,
              let current = viewModel.currentWeight else { return 0 }
        let totalToLose = start - target
        let lost = start - current
        return min(1, max(0, lost / totalToLose))
    }
    
    private func isThisWeek(_ dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return false }
        
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let currentWeekOfYear = calendar.component(.weekOfYear, from: Date())
        let year = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        
        return weekOfYear == currentWeekOfYear && year == currentYear
    }
}
