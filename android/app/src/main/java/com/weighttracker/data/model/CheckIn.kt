package com.weighttracker.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "checkins")
data class CheckIn(
    @PrimaryKey
    val date: String,
    val createdAt: Long = System.currentTimeMillis()
)
