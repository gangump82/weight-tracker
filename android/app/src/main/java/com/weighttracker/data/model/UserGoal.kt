package com.weighttracker.data.model

data class UserGoal(
    val targetWeight: Double? = null,
    val height: Int? = null,
    val age: Int? = null,
    val gender: String? = null // "male" or "female"
)
