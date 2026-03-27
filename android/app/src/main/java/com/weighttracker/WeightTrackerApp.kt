package com.weighttracker

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import com.weighttracker.ui.screens.*
import com.weighttracker.ui.viewmodel.MainViewModel

enum class Screen {
    WEIGHT, EXERCISE, DIET, NUTRITIONIST, STATS
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WeightTrackerApp() {
    val viewModel: MainViewModel = viewModel()
    var currentScreen by remember { mutableStateOf(Screen.WEIGHT) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        when (currentScreen) {
                            Screen.WEIGHT -> "⚖️ 体重记录"
                            Screen.EXERCISE -> "🏃 运动记录"
                            Screen.DIET -> "🥗 饮食记录"
                            Screen.NUTRITIONIST -> "👨‍⚕️ 营养师"
                            Screen.STATS -> "📊 统计"
                        }
                    )
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    titleContentColor = MaterialTheme.colorScheme.onPrimary
                )
            )
        },
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    selected = currentScreen == Screen.WEIGHT,
                    onClick = { currentScreen = Screen.WEIGHT },
                    icon = { Icon(Icons.Default.MonitorWeight, contentDescription = null) },
                    label = { Text("体重") }
                )
                NavigationBarItem(
                    selected = currentScreen == Screen.EXERCISE,
                    onClick = { currentScreen = Screen.EXERCISE },
                    icon = { Icon(Icons.Default.DirectionsRun, contentDescription = null) },
                    label = { Text("运动") }
                )
                NavigationBarItem(
                    selected = currentScreen == Screen.DIET,
                    onClick = { currentScreen = Screen.DIET },
                    icon = { Icon(Icons.Default.Restaurant, contentDescription = null) },
                    label = { Text("饮食") }
                )
                NavigationBarItem(
                    selected = currentScreen == Screen.NUTRITIONIST,
                    onClick = { currentScreen = Screen.NUTRITIONIST },
                    icon = { Icon(Icons.Default.Person, contentDescription = null) },
                    label = { Text("营养师") }
                )
                NavigationBarItem(
                    selected = currentScreen == Screen.STATS,
                    onClick = { currentScreen = Screen.STATS },
                    icon = { Icon(Icons.Default.BarChart, contentDescription = null) },
                    label = { Text("统计") }
                )
            }
        }
    ) { padding ->
        Box(modifier = Modifier.padding(padding)) {
            when (currentScreen) {
                Screen.WEIGHT -> WeightScreen(viewModel)
                Screen.EXERCISE -> ExerciseScreen(viewModel)
                Screen.DIET -> DietScreen(viewModel)
                Screen.NUTRITIONIST -> NutritionistScreen(viewModel)
                Screen.STATS -> StatsScreen(viewModel)
            }
        }
    }
}
