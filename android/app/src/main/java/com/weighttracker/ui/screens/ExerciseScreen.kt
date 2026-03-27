package com.weighttracker.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.weighttracker.data.model.Exercise
import com.weighttracker.ui.viewmodel.ExerciseStats
import com.weighttracker.ui.viewmodel.MainViewModel
import java.text.SimpleDateFormat
import java.util.*

val EXERCISE_TYPES = mapOf(
    "running" to Pair("跑步", "🏃"),
    "swimming" to Pair("游泳", "🏊"),
    "cycling" to Pair("骑行", "🚴"),
    "gym" to Pair("健身", "🏋️"),
    "yoga" to Pair("瑜伽", "🧘"),
    "walking" to Pair("步行", "🚶"),
    "jumping" to Pair("跳绳", "⏫"),
    "hiit" to Pair("HIIT", "⚡")
)

val CALORIES_PER_MIN = mapOf(
    "running" to 10,
    "swimming" to 8,
    "cycling" to 7,
    "gym" to 6,
    "yoga" to 3,
    "walking" to 4,
    "jumping" to 12,
    "hiit" to 14
)

@Composable
fun ExerciseScreen(viewModel: MainViewModel = viewModel()) {
    val exerciseStats by viewModel.exerciseStats.collectAsState()
    val exercises by viewModel.exercises.collectAsState(initial = emptyList())
    
    var showAddDialog by remember { mutableStateOf(false) }
    var selectedType by remember { mutableStateOf("running") }
    var duration by remember { mutableStateOf("") }
    var selectedDate by remember { mutableStateOf(SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Today Stats
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = Color(0xFF22C55E).copy(alpha = 0.1f)
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("🏃 今日运动", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("次数", "${exerciseStats.todayCount}")
                    StatItem("时长", "${exerciseStats.todayMinutes}分钟")
                    StatItem("消耗", "${exerciseStats.todayCalories}kcal")
                }
            }
        }
        
        // Week Stats
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("📊 本周统计", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    StatItem("运动次数", "${exerciseStats.weekCount}")
                    StatItem("总时长", "${exerciseStats.weekMinutes}分钟")
                    StatItem("总消耗", "${exerciseStats.weekCalories}kcal")
                }
            }
        }
        
        // Add Exercise Button
        Button(
            onClick = { showAddDialog = true },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.Add, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("记录运动")
        }
        
        // Exercise History
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("📋 运动历史", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                
                if (exercises.isEmpty()) {
                    Text("暂无运动记录", color = Color.Gray, modifier = Modifier.padding(16.dp))
                } else {
                    exercises.take(20).forEach { exercise ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 8.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(EXERCISE_TYPES[exercise.type]?.second ?: "🏃", fontSize = 24.sp)
                                Spacer(modifier = Modifier.width(8.dp))
                                Column {
                                    Text(exercise.typeName, fontWeight = FontWeight.Medium)
                                    Text("${exercise.date} · ${exercise.duration}分钟", fontSize = 12.sp, color = Color.Gray)
                                }
                            }
                            
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text("${exercise.calories} kcal", color = Color(0xFFF97316), fontWeight = FontWeight.Bold)
                                IconButton(onClick = { viewModel.deleteExercise(exercise.id) }) {
                                    Icon(Icons.Default.Delete, contentDescription = "删除", tint = Color.Red)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Add Exercise Dialog
    if (showAddDialog) {
        AlertDialog(
            onDismissRequest = { showAddDialog = false },
            title = { Text("记录运动") },
            text = {
                Column {
                    OutlinedTextField(
                        value = selectedDate,
                        onValueChange = { selectedDate = it },
                        label = { Text("日期") },
                        modifier = Modifier.fillMaxWidth()
                    )
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("运动类型", fontSize = 12.sp, color = Color.Gray)
                    
                    // Exercise Type Grid
                    Column {
                        EXERCISE_TYPES.entries.chunked(4).forEach { row ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                row.forEach { (type, pair) ->
                                    FilterChip(
                                        selected = selectedType == type,
                                        onClick = { selectedType = type },
                                        label = { Text("${pair.second} ${pair.first}") },
                                        modifier = Modifier.weight(1f)
                                    )
                                }
                            }
                            Spacer(modifier = Modifier.height(4.dp))
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = duration,
                        onValueChange = { duration = it },
                        label = { Text("运动时长 (分钟)") },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )
                    
                    // Auto-calculate calories
                    duration.toIntOrNull()?.let { mins ->
                        val calories = mins * (CALORIES_PER_MIN[selectedType] ?: 5)
                        Text("预计消耗: $calories kcal", fontSize = 12.sp, color = Color.Gray)
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        duration.toIntOrNull()?.let { mins ->
                            val calories = mins * (CALORIES_PER_MIN[selectedType] ?: 5)
                            val typeInfo = EXERCISE_TYPES[selectedType]!!
                            viewModel.addExercise(
                                Exercise(
                                    date = selectedDate,
                                    type = selectedType,
                                    typeName = typeInfo.first,
                                    typeIcon = typeInfo.second,
                                    duration = mins,
                                    calories = calories
                                )
                            )
                            duration = ""
                            showAddDialog = false
                        }
                    }
                ) {
                    Text("保存")
                }
            },
            dismissButton = {
                TextButton(onClick = { showAddDialog = false }) {
                    Text("取消")
                }
            }
        )
    }
}

@Composable
fun StatItem(label: String, value: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
        Text(label, fontSize = 12.sp, color = Color.Gray)
    }
}
