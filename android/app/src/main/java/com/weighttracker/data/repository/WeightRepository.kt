package com.weighttracker.data.repository

import com.weighttracker.data.database.*
import com.weighttracker.data.model.*
import kotlinx.coroutines.flow.Flow
import java.text.SimpleDateFormat
import java.util.*

class WeightRepository(
    private val weightRecordDao: WeightRecordDao,
    private val checkInDao: CheckInDao,
    private val exerciseDao: ExerciseDao,
    private val dietDao: DietDao,
    private val mealPlanDao: MealPlanDao
) {
    // Weight Records
    fun getAllWeightRecords(): Flow<List<WeightRecord>> = weightRecordDao.getAll()
    fun getAllWeightRecordsAscending(): Flow<List<WeightRecord>> = weightRecordDao.getAllAscending()
    suspend fun getWeightRecordByDate(date: String): WeightRecord? = weightRecordDao.getByDate(date)
    suspend fun insertWeightRecord(record: WeightRecord) = weightRecordDao.insert(record)
    suspend fun deleteWeightRecord(date: String) = weightRecordDao.deleteByDate(date)
    
    // Check-ins
    fun getAllCheckIns(): Flow<List<CheckIn>> = checkInDao.getAll()
    suspend fun getCheckInByDate(date: String): CheckIn? = checkInDao.getByDate(date)
    suspend fun insertCheckIn(checkIn: CheckIn) = checkInDao.insert(checkIn)
    suspend fun deleteCheckIn(checkIn: CheckIn) = checkInDao.delete(checkIn)
    
    // Exercises
    fun getAllExercises(): Flow<List<Exercise>> = exerciseDao.getAll()
    fun getExercisesByDate(date: String): Flow<List<Exercise>> = exerciseDao.getByDate(date)
    suspend fun insertExercise(exercise: Exercise) = exerciseDao.insert(exercise)
    suspend fun deleteExercise(id: Long) = exerciseDao.deleteById(id)
    
    // Diets
    fun getAllDiets(): Flow<List<Diet>> = dietDao.getAll()
    fun getDietsByDate(date: String): Flow<List<Diet>> = dietDao.getByDate(date)
    suspend fun insertDiet(diet: Diet) = dietDao.insert(diet)
    suspend fun deleteDiet(id: Long) = dietDao.deleteById(id)
    
    // Meal Plans
    suspend fun getLatestMealPlan(): MealPlan? = mealPlanDao.getLatest()
    suspend fun insertMealPlan(mealPlan: MealPlan) = mealPlanDao.insert(mealPlan)
    suspend fun clearMealPlans() = mealPlanDao.deleteAll()
    
    companion object {
        fun getToday(): String {
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            return sdf.format(Date())
        }
        
        fun formatDate(date: Date): String {
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            return sdf.format(date)
        }
    }
}
