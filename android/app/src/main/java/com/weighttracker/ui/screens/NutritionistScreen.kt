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
import kotlinx.serialization.Serializable

@Serializable
data class Recipe(
    val name: String,
    val calories: Int,
    val protein: Int,
    val carbs: Int,
    val fat: Int,
    val fiber: Int
)

@Serializable
data class DayMealPlan(
    val dayIndex: Int,
    val breakfast: Recipe,
    val lunch: Recipe,
    val dinner: Recipe,
    val snack: Recipe,
    val totalCalories: Int
)

val PEOPLE_TYPES = listOf(
    "👶 婴儿(6-12月)" to "baby",
    "🧒 幼儿(1-3岁)" to "toddler",
    "👦 儿童(4-12岁)" to "child",
    "🤰 孕妇" to "pregnant",
    "🤱 哺乳期" to "lactating",
    "💪 健身人士" to "fitness",
    "🏋️ 增肌人群" to "muscle_gain",
    "👴 中老年人" to "elderly",
    "🧓 养生保健" to "senior_health",
    "🧘 减脂人群" to "weight_loss",
    "🩺 糖尿病" to "diabetic",
    "📚 学生党" to "student"
)

val BREAKFAST_RECIPES = listOf(
    Recipe("燕麦粥+鸡蛋+牛奶", 380, 18, 45, 12, 5),
    Recipe("全麦面包+煎蛋+酸奶", 420, 20, 48, 15, 4),
    Recipe("小米粥+肉包子+豆浆", 450, 18, 60, 14, 3),
    Recipe("鸡蛋灌饼+豆浆", 480, 16, 55, 20, 2),
    Recipe("杂粮馒头+鸡蛋+牛奶", 400, 18, 50, 12, 6),
    Recipe("蔬菜鸡蛋饼+小米粥", 360, 15, 42, 14, 4),
    Recipe("玉米+煮鸡蛋+豆浆", 350, 16, 40, 12, 5)
)

val LUNCH_RECIPES = listOf(
    Recipe("米饭+清蒸鱼+炒青菜", 550, 28, 70, 15, 5),
    Recipe("米饭+红烧鸡块+炒西兰花", 620, 30, 75, 20, 4),
    Recipe("面条+番茄牛腩+青菜", 600, 25, 80, 18, 4),
    Recipe("杂粮饭+豆腐烧肉+炒时蔬", 580, 24, 72, 18, 6),
    Recipe("米饭+宫保鸡丁+凉拌黄瓜", 560, 26, 68, 18, 3),
    Recipe("糙米饭+清炒虾仁+炒芦笋", 520, 28, 65, 14, 5),
    Recipe("米饭+番茄炒蛋+清炒豆角", 500, 20, 70, 15, 4)
)

val DINNER_RECIPES = listOf(
    Recipe("小米粥+清炒时蔬+煎饺", 450, 16, 58, 16, 4),
    Recipe("米饭+蒜蓉虾+炒豆苗", 520, 26, 65, 15, 4),
    Recipe("杂粮粥+肉末茄子+凉菜", 480, 18, 60, 16, 5),
    Recipe("馒头+冬瓜排骨汤+炒青菜", 500, 22, 62, 16, 4),
    Recipe("米饭+香菇滑鸡+炒西兰花", 530, 24, 65, 17, 5),
    Recipe("蔬菜汤面+卤蛋+小菜", 420, 18, 58, 12, 4),
    Recipe("红薯粥+清蒸蛋+凉拌黄瓜", 380, 14, 55, 10, 4)
)

val SNACK_RECIPES = listOf(
    Recipe("苹果", 95, 0, 25, 0, 4),
    Recipe("酸奶", 120, 6, 15, 4, 0),
    Recipe("坚果一小把", 150, 5, 6, 13, 2),
    Recipe("香蕉", 105, 1, 27, 0, 3),
    Recipe("牛奶", 150, 8, 12, 8, 0),
    Recipe("橙子", 65, 1, 16, 0, 3),
    Recipe("全麦饼干+芝士", 140, 5, 15, 7, 2)
)

@Composable
fun NutritionistScreen(viewModel: MainViewModel = viewModel()) {
    var selectedPeopleType by remember { mutableStateOf("weight_loss") }
    var selectedSpecialNeed by remember { mutableStateOf("") }
    var selectedPreference by remember { mutableStateOf("normal") }
    var mealPlan by remember { mutableStateOf<List<DayMealPlan>>(emptyList()) }
    var selectedDay by remember { mutableStateOf(0) }
    
    val specialNeeds = listOf(
        "无特殊需求" to "",
        "糖尿病" to "diabetes",
        "高血压" to "hypertension",
        "高血脂" to "hyperlipidemia",
        "痛风" to "gout",
        "贫血" to "anemia"
    )
    
    val preferences = listOf(
        "正常饮食" to "normal",
        "素食" to "vegetarian",
        "低碳水" to "lowCarb",
        "高蛋白" to "highProtein",
        "清淡饮食" to "light"
    )
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header Card
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = Color(0xFF22C55E).copy(alpha = 0.1f)
            )
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("👨‍⚕️ 顶级营养师", fontWeight = FontWeight.Bold, fontSize = 18.sp)
                Text("基于您的身体状况和目标，为您量身定制一周营养食谱", fontSize = 12.sp, color = Color.Gray)
            }
        }
        
        // People Type Selection
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("选择人群类型", fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(8.dp))
                
                PEOPLE_TYPES.chunked(3).forEach { row ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        row.forEach { (label, value) ->
                            FilterChip(
                                selected = selectedPeopleType == value,
                                onClick = { selectedPeopleType = value },
                                label = { Text(label, fontSize = 10.sp) },
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                }
            }
        }
        
        // Special Need & Preference
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Card(modifier = Modifier.weight(1f)) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("特殊需求", fontWeight = FontWeight.Bold, fontSize = 12.sp)
                    Spacer(modifier = Modifier.height(4.dp))
                    specialNeeds.forEach { (label, value) ->
                        if (selectedSpecialNeed == value) {
                            Text(label, fontSize = 12.sp, color = MaterialTheme.colorScheme.primary)
                        }
                    }
                }
            }
            
            Card(modifier = Modifier.weight(1f)) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("饮食偏好", fontWeight = FontWeight.Bold, fontSize = 12.sp)
                    Spacer(modifier = Modifier.height(4.dp))
                    preferences.forEach { (label, value) ->
                        if (selectedPreference == value) {
                            Text(label, fontSize = 12.sp, color = MaterialTheme.colorScheme.primary)
                        }
                    }
                }
            }
        }
        
        // Generate Button
        Button(
            onClick = {
                mealPlan = generateWeeklyMealPlan()
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.AutoFixHigh, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("🧬 生成专属食谱")
        }
        
        // Meal Plan Display
        if (mealPlan.isNotEmpty()) {
            // Day Selector
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                listOf("周一", "周二", "周三", "周四", "周五", "周六", "周日").forEachIndexed { idx, day ->
                    FilterChip(
                        selected = selectedDay == idx,
                        onClick = { selectedDay = idx },
                        label = { Text(day) },
                        modifier = Modifier.weight(1f)
                    )
                }
            }
            
            // Daily Meal Plan
            if (selectedDay < mealPlan.size) {
                val day = mealPlan[selectedDay]
                
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
                        
                        Divider(modifier = Modifier.padding(vertical = 8.dp))
                        Text("当日总计: ${day.totalCalories} kcal", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                    }
                }
            }
        }
    }
}

fun generateWeeklyMealPlan(): List<DayMealPlan> {
    val plans = mutableListOf<DayMealPlan>()
    
    for (i in 0 until 7) {
        val breakfast = BREAKFAST_RECIPES.random()
        val lunch = LUNCH_RECIPES.random()
        val dinner = DINNER_RECIPES.random()
        val snack = SNACK_RECIPES.random()
        
        plans.add(
            DayMealPlan(
                dayIndex = i,
                breakfast = breakfast,
                lunch = lunch,
                dinner = dinner,
                snack = snack,
                totalCalories = breakfast.calories + lunch.calories + dinner.calories + snack.calories
            )
        )
    }
    
    return plans
}
