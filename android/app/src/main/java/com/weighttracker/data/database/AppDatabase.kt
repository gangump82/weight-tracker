package com.weighttracker.data.database

import androidx.room.Database
import androidx.room.RoomDatabase
import com.weighttracker.data.model.*

@Database(
    entities = [
        WeightRecord::class,
        CheckIn::class,
        Exercise::class,
        Diet::class,
        MealPlan::class
    ],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun weightRecordDao(): WeightRecordDao
    abstract fun checkInDao(): CheckInDao
    abstract fun exerciseDao(): ExerciseDao
    abstract fun dietDao(): DietDao
    abstract fun mealPlanDao(): MealPlanDao
}
