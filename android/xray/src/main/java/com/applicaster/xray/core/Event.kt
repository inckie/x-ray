package com.applicaster.xray.core

data class Event(
        val tag: String,
        val subsystem: String,
        val timestamp: Long, // UTC
        val level: Int,
        val message: String,
        val data: MutableMap<String, Any>?,
        val context: MutableMap<String, Any>?,
        val exception: Throwable? // todo: not sure about this one, maybe handle it in event builder and add to data?
)