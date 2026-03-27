package com.weighttracker.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Room
import com.weighttracker.data.database.AppDatabase
import com.weighttracker.data.model.*
import com.weighttracker.data.repository.WeightRepository
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.*

data class WeightStats(
    val currentWeight: Double? = null,
    val startWeight: Double? = null,
    val targetWeight: Double? = null,
    val weightLost: Double = 0.0,
    val bmi: Double? = null,
    val weekLost: Double = 0.0,
    val monthLost: Double = 0.0,
    val streakDays: Int = 0
)

data class ExerciseStats(
    val todayCount: Int = 0,
    val todayMinutes: Int = 0,
    val todayCalories: Int = 0,
    val weekCount: Int = 0,
    val weekMinutes: Int = 0,
    val weekCalories: Int = 0
)

data class DietStats(
    val todayCalories: Int = 0,
    val weekCalories: Int = 0,
    val weekDays: Int = 0
)

class MainViewModel(application: Application) : AndroidViewModel(application) {
    
    private val db = Room.databaseBuilder(
        application,
        AppDatabase::class.java,
        "weight_tracker_db"
    ).build()
    
    private val repository = WeightRepository(
        db.weightRecordDao(),
        db.checkInDao(),
        db.exerciseDao(),
        db.dietDao(),
        db.mealPlanDao()
    )
    
    // User Goal (stored in DataStore)
    private val _userGoal = MutableStateFlow(UserGoal())
    val userGoal: StateFlow<UserGoal> = _userGoal.asStateFlow()
    
    // Weight Records
    val weightRecords: Flow<List<WeightRecord>> = repository.getAllWeightRecordsAscending()
    
    // Check-ins
    val checkIns: Flow<List<CheckIn>> = repository.getAllCheckIns()
    
    // Exercises
    val exercises: Flow<List<Exercise>> = repository.getAllExercises()
    
    // Diets
    val diets: Flow<List<Diet>> = repository.getAllDiets()
    
    // Stats
    private val _weightStats = MutableStateFlow(WeightStats())
    val weightStats: StateFlow<WeightStats> = _weightStats.asStateFlow()
    
    private val _exerciseStats = MutableStateFlow(ExerciseStats())
    val exerciseStats: StateFlow<ExerciseStats> = _exerciseStats.asStateFlow()
    
    private val _dietStats = MutableStateFlow(DietStats())
    val dietStats: StateFlow<DietStats> = _dietStats.asStateFlow()
    
    // Today's data
    val todayExercises: Flow<List<Exercise>> = repository.getExercisesByDate(WeightRepository.getToday())
    val todayDiets: Flow<List<Diet>> = repository.getDietsByDate(WeightRepository.getToday())
    
    init {
        calculateStats()
    }
    
    private fun calculateStats() {
        viewModelScope.launch {
            // Weight stats
            weightRecords.collect { records ->
                if (records.isNotEmpty()) {
                    val current = records.last().weight
                    val start = records.first().weight
                    val target = _userGoal.value.targetWeight
                    
                    // Calculate week/month loss
                    val calendar = Calendar.getInstance()
                    calendar.add(Calendar.DAY_OF_YEAR, -7)
                    val weekAgo = WeightRepository.formatDate(calendar.time)
                    val weekRecords = records.filter { it.date >= weekAgo }
                    val weekLost = if (weekRecords.size >= 2) weekRecords.first().weight - weekRecords.last().weight else 0.0
                    
                    calendar.time = Date()
                    calendar.add(Calendar.MONTH, -1)
                    val monthAgo = WeightRepository.formatDate(calendar.time)
                    val monthRecords = records.filter { it.date >= monthAgo }
                    val monthLost = if (monthRecords.size >= 2) monthRecords.first().weight - monthRecords.last().weight else 0.0
                    
                    // Calculate BMI
                    val height = _userGoal.value.height
                    val bmi = if (height != null) {
                        val heightM = height / 100.0
                        current / (heightM * heightM)
                    } else null
                    
                    _weightStats.value = WeightStats(
                        currentWeight = current,
                        startWeight = start,
                        targetWeight = target,
                        weightLost = start - current,
                        bmi = bmi,
                        weekLost = weekLost,
                        monthLost = monthLost,
                        streakDays = calculateStreak()
                    )
                }
            }
        }
        
        viewModelScope.launch {
            exercises.collect { allExercises ->
                val today = WeightRepository.getToday()
                val todayList = allExercises.filter { it.date == today }
                
                val calendar = Calendar.getInstance()
                calendar.add(Calendar.DAY_OF_YEAR, -7)
                val weekAgo = WeightRepository.formatDate(calendar.time)
                val weekList = allExercises.filter { it.date >= weekAgo }
                
                _exerciseStats.value = ExerciseStats(
                    todayCount = todayList.size,
                    todayMinutes = todayList.sumOf { it.duration },
                    todayCalories = todayList.sumOf { it.calories },
                    weekCount = weekList.size,
                    weekMinutes = weekList.sumOf { it.duration },
                    weekCalories = weekList.sumOf { it.calories }
                )
            }
        }
        
        viewModelScope.launch {
            diets.collect { allDiets ->
                val today = WeightRepository.getToday()
                val todayList = allDiets.filter { it.date == today }
                
                val calendar = Calendar.getInstance()
                calendar.add(Calendar.DAY_OF_YEAR, -7)
                val weekAgo = WeightRepository.formatDate(calendar.time)
                val weekList = allDiets.filter { it.date >= weekAgo }
                
                _dietStats.value = DietStats(
                    todayCalories = todayList.sumOf { it.calories },
                    weekCalories = weekList.sumOf { it.calories },
                    weekDays = weekList.map { it.date }.distinct().size
                )
            }
        }
    }
    
    private suspend fun calculateStreak(): Int {
        val checkInList = checkIns.first()
        if (checkInList.isEmpty()) return 0
        
        val sortedDates = checkInList.map { it.date }.sortedDescending()
        var streak = 0
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        
        for (i in sortedDates.indices) {
            val expectedDate = WeightRepository.formatDate(calendar.time)
            if (sortedDates.contains(expectedDate)) {
                streak++
                calendar.add(Calendar.DAY_OF_YEAR, -1)
            } else {
                break
            }
        }
        
        return streak
    }
    
    // Weight operations
    fun addWeightRecord(date: String, weight: Double) {
        viewModelScope.launch {
            repository.insertWeightRecord(WeightRecord(date, weight))
        }
    }
    
    fun deleteWeightRecord(date: String) {
        viewModelScope.launch {
            repository.deleteWeightRecord(date)
        }
    }
    
    // Check-in operations
    fun toggleCheckIn() {
        viewModelScope.launch {
            val today = WeightRepository.getToday()
            val existing = repository.getCheckInByDate(today)
            if (existing != null) {
                repository.deleteCheckIn(existing)
            } else {
                repository.insertCheckIn(CheckIn(today))
            }
        }
    }
    
    // Exercise operations
    fun addExercise(exercise: Exercise) {
        viewModelScope.launch {
            repository.insertExercise(exercise)
        }
    }
    
    fun deleteExercise(id: Long) {
        viewModelScope.launch {
            repository.deleteExercise(id)
        }
    }
    
    // Diet operations
    fun addDiet(diet: Diet) {
        viewModelScope.launch {
            repository.insertDiet(diet)
        }
    }
    
    fun deleteDiet(id: Long) {
        viewModelScope.launch {
            repository.deleteDiet(id)
        }
    }
    
    // User Goal
    fun setUserGoal(goal: UserGoal) {
        _userGoal.value = goal
    }
}
