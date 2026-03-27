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
import com.weighttracker.ui.viewmodel.MainViewModel
import java.text.SimpleDateFormat
import java.util.*

val EXERCISE_TYPES = listOf(
    Triple("running", "跑步 🏃", 10),
    Triple("swimming", "游泳 🏊", 8),
    Triple("cycling", "骑行 🚴", 7),
    Triple("gym", "健身 🏋️", 6),
    Triple("yoga", "瑜伽 🧘", 3),
    Triple("walking", "步行 🚶", 4),
    Triple("jumping", "跳绳 ⏫", 12),
    Triple("hiit", "HIIT ⚡", 14)
)

@Composable
fun ExerciseScreen(viewModel: MainViewModel = viewModel()) {
    val exerciseStats by viewModel.exerciseStats.collectAsState()
    val exercises by viewModel.exercises.collectAsState()
    
    var showAddDialog by remember { mutableStateOf(false) }
    var selectedType by remember { mutableStateOf(EXERCISE_TYPES[0]) }
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
                    horizontalArrangement = Arrangement.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("${exerciseStats.todayCalories}", fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Color(0xFF22C55E))
                        Text("消耗 kcal", fontSize = 12.sp, color = Color.Gray)
                    }
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
                            Column {
                                Text(exercise.typeName, fontWeight = FontWeight.Medium)
                                Text("${exercise.date} · ${exercise.duration}分钟", fontSize = 12.sp, color = Color.Gray)
                            }
                            
                            Text("${exercise.calories} kcal", color = Color(0xFFF97316), fontWeight = FontWeight.Bold)
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
                    
                    Column {
                        EXERCISE_TYPES.chunked(4).forEach { row ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                row.forEach { (type, name, _) ->
                                    FilterChip(
                                        selected = selectedType.first == type,
                                        onClick = { selectedType = Triple(type, name, selectedType.third) },
                                        label = { Text(name, fontSize = 10.sp) },
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
                    
                    duration.toIntOrNull()?.let { mins ->
                        val calories = mins * selectedType.third
                        Text("预计消耗: $calories kcal", fontSize = 12.sp, color = Color.Gray)
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        duration.toIntOrNull()?.let { mins ->
                            val calories = mins * selectedType.third
                            viewModel.addExercise(
                                date = selectedDate,
                                type = selectedType.first,
                                typeName = selectedType.second,
                                typeIcon = "",
                                duration = mins,
                                calories = calories
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
