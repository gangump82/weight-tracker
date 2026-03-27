package com.weighttracker.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "weight_records")
data class WeightRecord(
    @PrimaryKey
    val date: String,
    val weight: Double,
    val createdAt: Long = System.currentTimeMillis()
)
