package com.applicaster.xray.core

data class Event(
    val category: String,
    val subsystem: String,
    val timestamp: Long, // UTC
    val level: Int,
    val message: String,
    val data: Map<String, Any>?,
    val context: Map<String, Any>?,
    val exception: Throwable? // todo: not sure about this one, maybe handle it in event builder and add to data?
)