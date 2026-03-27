package com.weighttracker.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "exercises")
data class Exercise(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val date: String,
    val type: String,
    val typeName: String,
    val typeIcon: String,
    val duration: Int, // minutes
    val calories: Int,
    val createdAt: Long = System.currentTimeMillis()
)
