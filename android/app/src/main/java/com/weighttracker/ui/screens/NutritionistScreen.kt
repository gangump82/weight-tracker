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

data class Recipe(
    val name: String,
    val calories: Int
)

data class DayMealPlan(
    val dayIndex: Int,
    val breakfast: Recipe,
    val lunch: Recipe,
    val dinner: Recipe,
    val snack: Recipe
) {
    val totalCalories: Int get() = breakfast.calories + lunch.calories + dinner.calories + snack.calories
}

val BREAKFAST_RECIPES = listOf(
    Recipe("燕麦粥+鸡蛋+牛奶", 380),
    Recipe("全麦面包+煎蛋+酸奶", 420),
    Recipe("小米粥+肉包子+豆浆", 450),
    Recipe("鸡蛋灌饼+豆浆", 480),
    Recipe("杂粮馒头+鸡蛋+牛奶", 400),
    Recipe("蔬菜鸡蛋饼+小米粥", 360),
    Recipe("玉米+煮鸡蛋+豆浆", 350)
)

val LUNCH_RECIPES = listOf(
    Recipe("米饭+清蒸鱼+炒青菜", 550),
    Recipe("米饭+红烧鸡块+炒西兰花", 620),
    Recipe("面条+番茄牛腩+青菜", 600),
    Recipe("杂粮饭+豆腐烧肉+炒时蔬", 580),
    Recipe("米饭+宫保鸡丁+凉拌黄瓜", 560),
    Recipe("糙米饭+清炒虾仁+炒芦笋", 520),
    Recipe("米饭+番茄炒蛋+清炒豆角", 500)
)

val DINNER_RECIPES = listOf(
    Recipe("小米粥+清炒时蔬+煎饺", 450),
    Recipe("米饭+蒜蓉虾+炒豆苗", 520),
    Recipe("杂粮粥+肉末茄子+凉菜", 480),
    Recipe("馒头+冬瓜排骨汤+炒青菜", 500),
    Recipe("米饭+香菇滑鸡+炒西兰花", 530),
    Recipe("蔬菜汤面+卤蛋+小菜", 420),
    Recipe("红薯粥+清蒸蛋+凉拌黄瓜", 380)
)

val SNACK_RECIPES = listOf(
    Recipe("苹果", 95),
    Recipe("酸奶", 120),
    Recipe("坚果一小把", 150),
    Recipe("香蕉", 105),
    Recipe("牛奶", 150),
    Recipe("橙子", 65),
    Recipe("全麦饼干+芝士", 140)
)

@Composable
fun NutritionistScreen(viewModel: MainViewModel = viewModel()) {
    var mealPlans by remember { mutableStateOf<List<DayMealPlan>>(emptyList()) }
    var selectedDay by remember { mutableStateOf(0) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = Color(0xFF22C55E).copy(alpha = 0.1f)
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("👨‍⚕️ 顶级营养师", fontWeight = FontWeight.Bold, fontSize = 18.sp)
                Text("为您量身定制一周营养食谱", fontSize = 12.sp, color = Color.Gray)
            }
        }
        
        // Generate Button
        Button(
            onClick = {
                mealPlans = (0 until 7).map { index ->
                    DayMealPlan(
                        dayIndex = index,
                        breakfast = BREAKFAST_RECIPES.random(),
                        lunch = LUNCH_RECIPES.random(),
                        dinner = DINNER_RECIPES.random(),
                        snack = SNACK_RECIPES.random()
                    )
                }
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.AutoFixHigh, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("🧬 生成专属食谱")
        }
        
        // Meal Plan
        if (mealPlans.isNotEmpty()) {
            // Day Selector
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                listOf("周一", "周二", "周三", "周四", "周五", "周六", "周日").forEachIndexed { idx, day ->
                    FilterChip(
                        selected = selectedDay == idx,
                        onClick = { selectedDay = idx },
                        label = { Text(day, fontSize = 10.sp) },
                        modifier = Modifier.weight(1f)
                    )
                }
            }
            
            // Daily Plan
            if (selectedDay < mealPlans.size) {
                val day = mealPlans[selectedDay]
                
                Card(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        listOf(
                            "🌅 早餐" to day.breakfast,
                            "☀️ 午餐" to day.lunch,
                            "🌙 晚餐" to day.dinner,
                            "🍎 加餐" to day.snack
                        ).forEach { (mealName, recipe) ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 8.dp),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Column {
                                    Text(mealName, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                    Text(recipe.name, fontSize = 12.sp)
                                }
                                Text("${recipe.calories} kcal", color = Color(0xFFF97316), fontWeight = FontWeight.Bold)
                            }
                        }
                        
                        HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
                        Text("当日总计: ${day.totalCalories} kcal", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                    }
                }
            }
        }
    }
}
