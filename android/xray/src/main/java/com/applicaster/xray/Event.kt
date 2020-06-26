package com.applicaster.xray

import java.util.*

data class Event(
    val tag: String,
    val subsystem: String,
    val timestamp: Long, // UTC
    val level: Int,
    val message: String,
    val data: HashMap<String, Any>?,
    val context: LogContext?
)