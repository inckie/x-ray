package com.applicaster.xray

data class Event(
    val tag: String,
    val subsystem: String,
    val timestamp: Long, // UTC
    val level: Int,
    val message: String,
    val data: Map<String, Any>?,
    val context: Map<String, Any>?
)