import SwiftUI

struct WeightScreen: View {
    @ObservedObject var viewModel: WeightViewModel
    @State private var showAddSheet = false
    @State private var newWeight = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Check-in Card
                VStack(spacing: 12) {
                    HStack {
                        Text("🔥")
                            .font(.system(size: 40))
                        VStack(alignment: .leading) {
                            Text("\(viewModel.streakDays)")
                                .font(.system(size: 32, weight: .bold))
                            Text("连续打卡")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button(action: { viewModel.toggleCheckIn() }) {
                            Text(viewModel.isCheckedInToday() ? "✅ 已打卡" : "📅 今日打卡")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: viewModel.isCheckedInToday() 
                                            ? [Color.green, Color.green.opacity(0.8)]
                                            : [Color.red, Color.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(title: "当前体重", value: viewModel.currentWeight != nil 
                        ? String(format: "%.1fkg", viewModel.currentWeight!) : "--", color: .purple)
                    StatCard(title: "目标体重", value: viewModel.userGoal.targetWeight != nil 
                        ? String(format: "%.1fkg", viewModel.userGoal.targetWeight!) : "--", color: .green)
                    StatCard(title: "已减重", value: String(format: "%.1fkg", viewModel.weightLost), color: .blue)
                    StatCard(title: "BMI", value: viewModel.bmi != nil 
                        ? String(format: "%.1f", viewModel.bmi!) : "--", color: .orange)
                }
                
                // Progress
                if viewModel.startWeight != nil && viewModel.userGoal.targetWeight != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📊 减重进度")
                            .font(.headline)
                        
                        let progress = calculateProgress()
                        ProgressView(value: progress)
                            .tint(.purple)
                        
                        HStack {
                            Text("起始: \(String(format: "%.1f", viewModel.startWeight!))kg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(progress * 100))%")
                                .font(.headline)
                            Spacer()
                            Text("目标: \(String(format: "%.1f", viewModel.userGoal.targetWeight!))kg")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }
                
                // Add Button
                Button(action: { showAddSheet = true }) {
                    Label("记录体重", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.purple, .purple.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                
                // History
                VStack(alignment: .leading, spacing: 8) {
                    Text("📋 历史记录")
                        .font(.headline)
                    
                    if viewModel.weightRecords.isEmpty {
                        Text("暂无记录")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(viewModel.weightRecords.suffix(10).reversed()) { record in
                            HStack {
                                Text("\(record.weight)kg")
                                    .font(.headline)
                                Spacer()
                                Text(record.date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
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
        .navigationTitle("⚖️ 体重记录")
        .sheet(isPresented: $showAddSheet) {
            AddWeightSheet(viewModel: viewModel, newWeight: $newWeight, selectedDate: $selectedDate)
        }
    }
    
    private func calculateProgress() -> Double {
        guard let start = viewModel.startWeight,
              let target = viewModel.userGoal.targetWeight,
              let current = viewModel.currentWeight else { return 0 }
        let totalToLose = start - target
        let lost = start - current
        return min(1, max(0, lost / totalToLose))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct AddWeightSheet: View {
    @ObservedObject var viewModel: WeightViewModel
    @Binding var newWeight: String
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("日期", selection: $selectedDate, displayedComponents: .date)
                
                HStack {
                    Text("体重")
                    TextField("例如: 65.5", text: $newWeight)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("kg")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("记录体重")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if let weight = Double(newWeight) {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            viewModel.addWeightRecord(date: dateFormatter.string(from: selectedDate), weight: weight)
                            newWeight = ""
                            dismiss()
                        }
                    }
                    .disabled(newWeight.isEmpty)
                }
            }
        }
    }
}
