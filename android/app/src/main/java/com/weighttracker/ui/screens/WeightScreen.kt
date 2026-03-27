package com.weighttracker.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.weighttracker.ui.viewmodel.MainViewModel
import com.weighttracker.ui.viewmodel.WeightStats
import java.text.SimpleDateFormat
import java.util.*

@Composable
fun WeightScreen(viewModel: MainViewModel = viewModel()) {
    val weightStats by viewModel.weightStats.collectAsState()
    val weightRecords by viewModel.weightRecords.collectAsState(initial = emptyList())
    val checkIns by viewModel.checkIns.collectAsState(initial = emptyList())
    
    var showAddDialog by remember { mutableStateOf(false) }
    var newWeight by remember { mutableStateOf("") }
    var selectedDate by remember { mutableStateOf(SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Check-in Card
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.primaryContainer
            )
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("🔥", fontSize = 32.sp)
                    Spacer(modifier = Modifier.width(8.dp))
                    Column {
                        Text(
                            "${weightStats.streakDays}",
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                        Text(
                            "连续打卡",
                            fontSize = 12.sp,
                            color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f)
                        )
                    }
                }
                
                val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
                val checkedIn = checkIns.any { it.date == today }
                
                Button(
                    onClick = { viewModel.toggleCheckIn() },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (checkedIn) 
                            MaterialTheme.colorScheme.secondary 
                        else 
                            MaterialTheme.colorScheme.primary
                    )
                ) {
                    Text(if (checkedIn) "✅ 已打卡" else "📅 今日打卡")
                }
            }
        }
        
        // Stats Grid
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            StatCard(
                modifier = Modifier.weight(1f),
                title = "当前体重",
                value = weightStats.currentWeight?.let { "${it}kg" } ?: "--",
                color = Color(0xFF8B5CF6)
            )
            StatCard(
                modifier = Modifier.weight(1f),
                title = "目标体重",
                value = weightStats.targetWeight?.let { "${it}kg" } ?: "--",
                color = Color(0xFF22C55E)
            )
        }
        
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            StatCard(
                modifier = Modifier.weight(1f),
                title = "已减重",
                value = "${String.format("%.1f", weightStats.weightLost)}kg",
                color = Color(0xFF3B82F6)
            )
            StatCard(
                modifier = Modifier.weight(1f),
                title = "BMI",
                value = weightStats.bmi?.let { String.format("%.1f", it) } ?: "--",
                color = Color(0xFFF97316)
            )
        }
        
        // Progress Section
        if (weightStats.targetWeight != null && weightStats.startWeight != null) {
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("📊 减重进度", fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(8.dp))
                    
                    val totalToLose = weightStats.startWeight!! - weightStats.targetWeight!!
                    val lost = weightStats.startWeight!! - (weightStats.currentWeight ?: weightStats.startWeight!!)
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
                        Text("起始: ${weightStats.startWeight}kg", fontSize = 12.sp, color = Color.Gray)
                        Text("${(progress * 100).toInt()}%", fontWeight = FontWeight.Bold)
                        Text("目标: ${weightStats.targetWeight}kg", fontSize = 12.sp, color = Color.Gray)
                    }
                }
            }
        }
        
        // Week/Month Stats
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            StatCard(
                modifier = Modifier.weight(1f),
                title = "本周减重",
                value = "${String.format("%.1f", weightStats.weekLost)}kg",
                color = Color(0xFF22C55E),
                small = true
            )
            StatCard(
                modifier = Modifier.weight(1f),
                title = "本月减重",
                value = "${String.format("%.1f", weightStats.monthLost)}kg",
                color = Color(0xFF3B82F6),
                small = true
            )
        }
        
        // Add Weight Button
        Button(
            onClick = { showAddDialog = true },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.Add, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("记录体重")
        }
        
        // History
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("📋 历史记录", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                
                if (weightRecords.isEmpty()) {
                    Text("暂无记录", color = Color.Gray, modifier = Modifier.padding(16.dp))
                } else {
                    weightRecords.takeLast(10).reversed().forEach { record ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 8.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("${record.weight}kg")
                            Text(record.date, color = Color.Gray, fontSize = 12.sp)
                        }
                    }
                }
            }
        }
    }
    
    // Add Weight Dialog
    if (showAddDialog) {
        AlertDialog(
            onDismissRequest = { showAddDialog = false },
            title = { Text("记录体重") },
            text = {
                Column {
                    OutlinedTextField(
                        value = selectedDate,
                        onValueChange = { selectedDate = it },
                        label = { Text("日期") },
                        modifier = Modifier.fillMaxWidth()
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = newWeight,
                        onValueChange = { newWeight = it },
                        label = { Text("体重 (kg)") },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        newWeight.toDoubleOrNull()?.let { weight ->
                            viewModel.addWeightRecord(selectedDate, weight)
                            newWeight = ""
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
fun StatCard(
    modifier: Modifier = Modifier,
    title: String,
    value: String,
    color: Color,
    small: Boolean = false
) {
    Card(
        modifier = modifier,
        colors = CardDefaults.cardColors(
            containerColor = color.copy(alpha = 0.1f)
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(if (small) 12.dp else 16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                value,
                fontSize = if (small) 18.sp else 24.sp,
                fontWeight = FontWeight.Bold,
                color = color
            )
            Text(
                title,
                fontSize = if (small) 10.sp else 12.sp,
                color = Color.Gray
            )
        }
    }
}
