package com.weighttracker.data.database

import androidx.room.*
import com.weighttracker.data.model.*
import kotlinx.coroutines.flow.Flow

@Dao
interface WeightRecordDao {
    @Query("SELECT * FROM weight_records ORDER BY date DESC")
    fun getAll(): Flow<List<WeightRecord>>
    
    @Query("SELECT * FROM weight_records ORDER BY date ASC")
    fun getAllAscending(): Flow<List<WeightRecord>>
    
    @Query("SELECT * FROM weight_records WHERE date = :date LIMIT 1")
    suspend fun getByDate(date: String): WeightRecord?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(record: WeightRecord)
    
    @Delete
    suspend fun delete(record: WeightRecord)
    
    @Query("DELETE FROM weight_records WHERE date = :date")
    suspend fun deleteByDate(date: String)
}

@Dao
interface CheckInDao {
    @Query("SELECT * FROM checkins ORDER BY date DESC")
    fun getAll(): Flow<List<CheckIn>>
    
    @Query("SELECT * FROM checkins WHERE date = :date LIMIT 1")
    suspend fun getByDate(date: String): CheckIn?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(checkIn: CheckIn)
    
    @Delete
    suspend fun delete(checkIn: CheckIn)
}

@Dao
interface ExerciseDao {
    @Query("SELECT * FROM exercises ORDER BY date DESC")
    fun getAll(): Flow<List<Exercise>>
    
    @Query("SELECT * FROM exercises WHERE date = :date")
    fun getByDate(date: String): Flow<List<Exercise>>
    
    @Insert
    suspend fun insert(exercise: Exercise)
    
    @Delete
    suspend fun delete(exercise: Exercise)
    
    @Query("DELETE FROM exercises WHERE id = :id")
    suspend fun deleteById(id: Long)
}

@Dao
interface DietDao {
    @Query("SELECT * FROM diets ORDER BY date DESC")
    fun getAll(): Flow<List<Diet>>
    
    @Query("SELECT * FROM diets WHERE date = :date")
    fun getByDate(date: String): Flow<List<Diet>>
    
    @Insert
    suspend fun insert(diet: Diet)
    
    @Delete
    suspend fun delete(diet: Diet)
    
    @Query("DELETE FROM diets WHERE id = :id")
    suspend fun deleteById(id: Long)
}

@Dao
interface MealPlanDao {
    @Query("SELECT * FROM meal_plans ORDER BY weekStart DESC LIMIT 1")
    suspend fun getLatest(): MealPlan?
    
    @Insert
    suspend fun insert(mealPlan: MealPlan)
    
    @Query("DELETE FROM meal_plans")
    suspend fun deleteAll()
}
