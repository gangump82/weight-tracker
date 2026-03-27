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
    val weightRecords by viewModel.weightRecords.collectAsState()
    
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
                    StatItem("今日消耗", "${exerciseStats.todayCalories}kcal")
                    StatItem("今日摄入", "${dietStats.todayCalories}kcal")
                }
            }
        }
        
        // Weight Progress
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("⚖️ 体重进度", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                if (weightStats.startWeight != null && weightStats.targetWeight != null && weightStats.currentWeight != null) {
                    val totalToLose = weightStats.startWeight!! - weightStats.targetWeight!!
                    val lost = weightStats.startWeight!! - weightStats.currentWeight!!
                    val progress = if (totalToLose > 0) (lost / totalToLose).toFloat().coerceIn(0f, 1f) else 0f
                    
                    LinearProgressIndicator(
                        progress = { progress },
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
                        Text("起始: ${String.format("%.1f", weightStats.startWeight!!)}kg", fontSize = 12.sp, color = Color.Gray)
                        Text("当前: ${String.format("%.1f", weightStats.currentWeight!!)}kg", fontSize = 12.sp, color = Color.Gray)
                        Text("目标: ${String.format("%.1f", weightStats.targetWeight!!)}kg", fontSize = 12.sp, color = Color.Gray)
                    }
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("完成度: ${(progress * 100).toInt()}%", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                } else {
                    Text("请先设置目标体重", color = Color.Gray)
                }
            }
        }
        
        // Calorie Balance
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("⚖️ 今日热量平衡", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                val netCalories = dietStats.todayCalories - exerciseStats.todayCalories
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("${dietStats.todayCalories}", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Color(0xFFF97316))
                        Text("摄入", fontSize = 12.sp, color = Color.Gray)
                    }
                    
                    Text("-", fontSize = 24.sp)
                    
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("${exerciseStats.todayCalories}", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = Color(0xFF22C55E))
                        Text("消耗", fontSize = 12.sp, color = Color.Gray)
                    }
                    
                    Text("=", fontSize = 24.sp)
                    
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("$netCalories", fontSize = 24.sp, fontWeight = FontWeight.Bold, color = if (netCalories > 0) Color.Red else Color.Blue)
                        Text("净热量", fontSize = 12.sp, color = Color.Gray)
                    }
                }
            }
        }
    }
}

@Composable
fun StatItem(label: String, value: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
        Text(label, fontSize = 12.sp, color = Color.Gray)
    }
}
