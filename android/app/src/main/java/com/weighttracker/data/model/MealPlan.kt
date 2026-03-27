package com.weighttracker.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "meal_plans")
data class MealPlan(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val weekStart: String, // Monday of the week
    val peopleType: String,
    val specialNeed: String?,
    val preference: String,
    val planData: String, // JSON string of the full week plan
    val createdAt: Long = System.currentTimeMillis()
)
