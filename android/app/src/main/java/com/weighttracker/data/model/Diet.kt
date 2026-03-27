package com.weighttracker.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "diets")
data class Diet(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val date: String,
    val mealType: String, // breakfast, lunch, dinner, snack
    val mealName: String,
    val mealIcon: String,
    val foods: String, // JSON string
    val calories: Int,
    val createdAt: Long = System.currentTimeMillis()
)
