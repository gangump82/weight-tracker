package com.weighttracker.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.weighttracker.ui.viewmodel.MainViewModel

@Composable
fun StatsScreen(viewModel: MainViewModel = viewModel()) {
    val weightStats by viewModel.weightStats.collectAsState()
    val exerciseStats by viewModel.exerciseStats.collectAsState()
    val dietStats by viewModel.dietStats.collectAsState()
    val weightRecords by viewModel.weightRecords.collectAsState(initial = emptyList())
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Comprehensive Stats
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("📊 综合统计", fontWeight = FontWeight.Bold, fontSize = 18.sp)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("记录天数", "${weightRecords.size}")
                    StatItem("总消耗", "${exerciseStats.weekCalories}kcal")
                    StatItem("总摄入", "${dietStats.weekCalories}kcal")
                }
            }
        }
        
        // Weight Progress
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("⚖️ 体重进度", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                weightStats.startWeight?.let { start ->
                    weightStats.currentWeight?.let { current ->
                        weightStats.targetWeight?.let { target ->
                            val totalToLose = start - target
                            val lost = start - current
                            val progress = if (totalToLose > 0) (lost / totalToLose).toFloat().coerceIn(0f, 1f) else 0f
                            
                            LinearProgressIndicator(
                                progress = progress,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(8.dp),
                                color = MaterialTheme.colorScheme.primary,
                                trackColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.2f)
                            )
                            
                            Spacer(modifier = Modifier.height(8.dp))
                            
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("起始: ${String.format("%.1f", start)}kg", fontSize = 12.sp, color = Color.Gray)
                                Text("当前: ${String.format("%.1f", current)}kg", fontSize = 12.sp, color = Color.Gray)
                                Text("目标: ${String.format("%.1f", target)}kg", fontSize = 12.sp, color = Color.Gray)
                            }
                            
                            Spacer(modifier = Modifier.height(8.dp))
                            Text("完成度: ${(progress * 100).toInt()}%", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                        }
                    }
                } ?: run {
                    Text("请先设置目标体重", color = Color.Gray)
                }
            }
        }
        
        // Exercise Summary
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("🏃 运动概览", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("本周次数", "${exerciseStats.weekCount}")
                    StatItem("本周时长", "${exerciseStats.weekMinutes}分钟")
                    StatItem("本周消耗", "${exerciseStats.weekCalories}kcal")
                }
            }
        }
        
        // Diet Summary
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("🥗 饮食概览", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("本周摄入", "${dietStats.weekCalories}kcal")
                    StatItem("日均摄入", if (dietStats.weekDays > 0) "${dietStats.weekCalories / dietStats.weekDays}kcal" else "--")
                    StatItem("记录天数", "${dietStats.weekDays}天")
                }
            }
        }
        
        // Calorie Balance
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("⚖️ 热量平衡", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                val netCalories = dietStats.todayCalories - exerciseStats.todayCalories
                val balanceText = if (netCalories > 0) "摄入 $netCalories kcal" else "消耗 ${-netCalories} kcal"
                val balanceColor = if (netCalories > 0) Color(0xFFF97316) else Color(0xFF22C55E)
                
                Text("今日净热量: $balanceText", color = balanceColor, fontWeight = FontWeight.Bold)
            }
        }
    }
}
