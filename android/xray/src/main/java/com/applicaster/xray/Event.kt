package com.applicaster.xray

import java.util.*

data class Event(
    val tag: String,
    val timestamp: Date,
    val level: Int,
    val message: String,
    val data: HashMap<String, Any>?,
    val context: LogContext?
)