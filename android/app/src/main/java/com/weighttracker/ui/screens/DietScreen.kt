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
import com.weighttracker.ui.viewmodel.MainViewModel
import java.text.SimpleDateFormat
import java.util.*

val MEAL_TYPES = listOf(
    Pair("breakfast", "早餐 🌅"),
    Pair("lunch", "午餐 ☀️"),
    Pair("dinner", "晚餐 🌙"),
    Pair("snack", "加餐 🍎")
)

@Composable
fun DietScreen(viewModel: MainViewModel = viewModel()) {
    val dietStats by viewModel.dietStats.collectAsState()
    val diets by viewModel.diets.collectAsState()
    
    var showAddDialog by remember { mutableStateOf(false) }
    var selectedMealType by remember { mutableStateOf(MEAL_TYPES[0]) }
    var foodName by remember { mutableStateOf("") }
    var calories by remember { mutableStateOf("") }
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
                containerColor = Color(0xFFF97316).copy(alpha = 0.1f)
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("🥗 今日饮食", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Spacer(modifier = Modifier.height(12.dp))
                
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Center
                ) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("${dietStats.todayCalories}", fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Color(0xFFF97316))
                        Text("摄入 kcal", fontSize = 12.sp, color = Color.Gray)
                    }
                }
            }
        }
        
        // Add Diet Button
        Button(
            onClick = { showAddDialog = true },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.Add, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("记录饮食")
        }
        
        // Diet History
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("📋 饮食历史", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                
                if (diets.isEmpty()) {
                    Text("暂无饮食记录", color = Color.Gray, modifier = Modifier.padding(16.dp))
                } else {
                    diets.take(20).forEach { diet ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 8.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Column {
                                Text(diet.mealName, fontWeight = FontWeight.Medium)
                                Text(diet.date, fontSize = 12.sp, color = Color.Gray)
                            }
                            
                            Text("${diet.calories} kcal", color = Color(0xFFF97316), fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }
    }
    
    // Add Diet Dialog
    if (showAddDialog) {
        AlertDialog(
            onDismissRequest = { showAddDialog = false },
            title = { Text("记录饮食") },
            text = {
                Column {
                    OutlinedTextField(
                        value = selectedDate,
                        onValueChange = { selectedDate = it },
                        label = { Text("日期") },
                        modifier = Modifier.fillMaxWidth()
                    )
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("餐次", fontSize = 12.sp, color = Color.Gray)
                    
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        MEAL_TYPES.forEach { (type, name) ->
                            FilterChip(
                                selected = selectedMealType.first == type,
                                onClick = { selectedMealType = Pair(type, name) },
                                label = { Text(name, fontSize = 10.sp) },
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = foodName,
                        onValueChange = { foodName = it },
                        label = { Text("食物名称") },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )
                    
                    Spacer(modifier = Modifier.height(8.dp))
                    OutlinedTextField(
                        value = calories,
                        onValueChange = { calories = it },
                        label = { Text("热量 (kcal)") },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        calories.toIntOrNull()?.let { cals ->
                            viewModel.addDiet(
                                date = selectedDate,
                                mealType = selectedMealType.first,
                                mealName = foodName.ifEmpty { selectedMealType.second },
                                mealIcon = "",
                                calories = cals
                            )
                            foodName = ""
                            calories = ""
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
