package com.weighttracker.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat
import java.util.*

@Serializable
data class WeightRecord(val date: String, val weight: Double)
@Serializable
data class CheckIn(val date: String)
@Serializable
data class ExerciseRecord(val date: String, val type: String, val typeName: String, val typeIcon: String, val duration: Int, val calories: Int)
@Serializable
data class DietRecord(val date: String, val mealType: String, val mealName: String, val mealIcon: String, val calories: Int)

private val Application.dataStore by preferencesDataStore(name = "weight_tracker")

data class WeightStats(
    val currentWeight: Double? = null,
    val startWeight: Double? = null,
    val targetWeight: Double? = null,
    val weightLost: Double = 0.0,
    val bmi: Double? = null,
    val streakDays: Int = 0
)

data class ExerciseStats(
    val todayCalories: Int = 0,
    val weekCalories: Int = 0
)

data class DietStats(
    val todayCalories: Int = 0,
    val weekCalories: Int = 0
)

class MainViewModel(application: Application) : AndroidViewModel(application) {
    
    private val dataStore = application.dataStore
    
    // Keys
    private val weightRecordsKey = stringPreferencesKey("weight_records")
    private val checkInsKey = stringPreferencesKey("check_ins")
    private val exercisesKey = stringPreferencesKey("exercises")
    private val dietsKey = stringPreferencesKey("diets")
    private val targetWeightKey = doublePreferencesKey("target_weight")
    private val heightKey = intPreferencesKey("height")
    
    // State
    private val _weightRecords = MutableStateFlow<List<WeightRecord>>(emptyList())
    private val _checkIns = MutableStateFlow<List<CheckIn>>(emptyList())
    private val _exercises = MutableStateFlow<List<ExerciseRecord>>(emptyList())
    private val _diets = MutableStateFlow<List<DietRecord>>(emptyList())
    private val _targetWeight = MutableStateFlow<Double?>(null)
    private val _height = MutableStateFlow<Int?>(null)
    
    val weightStats: StateFlow<WeightStats> = combine(_weightRecords, _checkIns, _targetWeight, _height) { records, checkIns, target, height ->
        val current = records.maxByOrNull { it.date }?.weight
        val start = records.minByOrNull { it.date }?.weight
        val bmi = if (height != null && current != null) {
            val h = height / 100.0
            current / (h * h)
        } else null
        
        val today = getToday()
        val sorted = checkIns.map { it.date }.sortedDescending()
        var streak = 0
        var checkDate = Calendar.getInstance()
        checkDate.set(Calendar.HOUR_OF_DAY, 0)
        checkDate.set(Calendar.MINUTE, 0)
        checkDate.set(Calendar.SECOND, 0)
        checkDate.set(Calendar.MILLISECOND, 0)
        
        for (i in sorted.indices) {
            val expected = formatDate(checkDate.time)
            if (sorted.contains(expected)) {
                streak++
                checkDate.add(Calendar.DAY_OF_YEAR, -1)
            } else break
        }
        
        WeightStats(
            currentWeight = current,
            startWeight = start,
            targetWeight = target,
            weightLost = if (start != null && current != null) start - current else 0.0,
            bmi = bmi,
            streakDays = streak
        )
    }.stateIn(viewModelScope, SharingStarted.Lazily, WeightStats())
    
    val exerciseStats: StateFlow<ExerciseStats> = _exercises.map { list ->
        val today = getToday()
        val todayCalories = list.filter { it.date == today }.sumOf { it.calories }
        val weekCalories = list.filter { isThisWeek(it.date) }.sumOf { it.calories }
        ExerciseStats(todayCalories, weekCalories)
    }.stateIn(viewModelScope, SharingStarted.Lazily, ExerciseStats())
    
    val dietStats: StateFlow<DietStats> = _diets.map { list ->
        val today = getToday()
        val todayCalories = list.filter { it.date == today }.sumOf { it.calories }
        val weekCalories = list.filter { isThisWeek(it.date) }.sumOf { it.calories }
        DietStats(todayCalories, weekCalories)
    }.stateIn(viewModelScope, SharingStarted.Lazily, DietStats())
    
    val weightRecords: StateFlow<List<WeightRecord>> = _weightRecords.asStateFlow()
    val exercises: StateFlow<List<ExerciseRecord>> = _exercises.asStateFlow()
    val diets: StateFlow<List<DietRecord>> = _diets.asStateFlow()
    val checkIns: StateFlow<List<CheckIn>> = _checkIns.asStateFlow()
    
    init {
        loadData()
    }
    
    private fun loadData() {
        viewModelScope.launch {
            dataStore.data.collect { prefs ->
                prefs[weightRecordsKey]?.let { json ->
                    _weightRecords.value = Json.decodeFromString(json)
                }
                prefs[checkInsKey]?.let { json ->
                    _checkIns.value = Json.decodeFromString(json)
                }
                prefs[exercisesKey]?.let { json ->
                    _exercises.value = Json.decodeFromString(json)
                }
                prefs[dietsKey]?.let { json ->
                    _diets.value = Json.decodeFromString(json)
                }
                _targetWeight.value = prefs[targetWeightKey]
                _height.value = prefs[heightKey]
            }
        }
    }
    
    private suspend fun saveData() {
        dataStore.edit { prefs ->
            prefs[weightRecordsKey] = Json.encodeToString(_weightRecords.value)
            prefs[checkInsKey] = Json.encodeToString(_checkIns.value)
            prefs[exercisesKey] = Json.encodeToString(_exercises.value)
            prefs[dietsKey] = Json.encodeToString(_diets.value)
            _targetWeight.value?.let { prefs[targetWeightKey] = it }
            _height.value?.let { prefs[heightKey] = it }
        }
    }
    
    fun getToday(): String = formatDate(Date())
    
    fun formatDate(date: Date): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return sdf.format(date)
    }
    
    private fun isThisWeek(dateStr: String): Boolean {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val date = sdf.parse(dateStr) ?: return false
        val cal = Calendar.getInstance()
        val weekStart = cal.apply { set(Calendar.DAY_OF_WEEK, Calendar.MONDAY); set(Calendar.HOUR_OF_DAY, 0) }.time
        val weekEnd = cal.apply { add(Calendar.DAY_OF_YEAR, 7) }.time
        return date in weekStart..weekEnd
    }
    
    fun addWeightRecord(date: String, weight: Double) {
        viewModelScope.launch {
            val list = _weightRecords.value.toMutableList()
            list.removeAll { it.date == date }
            list.add(WeightRecord(date, weight))
            _weightRecords.value = list.sortedBy { it.date }
            saveData()
        }
    }
    
    fun deleteWeightRecord(date: String) {
        viewModelScope.launch {
            _weightRecords.value = _weightRecords.value.filter { it.date != date }
            saveData()
        }
    }
    
    fun toggleCheckIn() {
        viewModelScope.launch {
            val today = getToday()
            val list = _checkIns.value.toMutableList()
            if (list.any { it.date == today }) {
                list.removeAll { it.date == today }
            } else {
                list.add(CheckIn(today))
            }
            _checkIns.value = list
            saveData()
        }
    }
    
    fun isCheckedInToday(): Boolean = _checkIns.value.any { it.date == getToday() }
    
    fun addExercise(date: String, type: String, typeName: String, typeIcon: String, duration: Int, calories: Int) {
        viewModelScope.launch {
            val list = _exercises.value.toMutableList()
            list.add(ExerciseRecord(date, type, typeName, typeIcon, duration, calories))
            _exercises.value = list
            saveData()
        }
    }
    
    fun deleteExercise(date: String, type: String) {
        viewModelScope.launch {
            _exercises.value = _exercises.value.filterNot { it.date == date && it.type == type }
            saveData()
        }
    }
    
    fun addDiet(date: String, mealType: String, mealName: String, mealIcon: String, calories: Int) {
        viewModelScope.launch {
            val list = _diets.value.toMutableList()
            list.add(DietRecord(date, mealType, mealName, mealIcon, calories))
            _diets.value = list
            saveData()
        }
    }
    
    fun deleteDiet(date: String, mealType: String) {
        viewModelScope.launch {
            _diets.value = _diets.value.filterNot { it.date == date && it.mealType == mealType }
            saveData()
        }
    }
    
    fun setTargetWeight(weight: Double) {
        viewModelScope.launch {
            _targetWeight.value = weight
            saveData()
        }
    }
    
    fun setHeight(height: Int) {
        viewModelScope.launch {
            _height.value = height
            saveData()
        }
    }
}
