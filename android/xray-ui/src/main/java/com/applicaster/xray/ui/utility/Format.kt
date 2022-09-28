package com.applicaster.xray.ui.utility

import com.applicaster.xray.core.Event
import com.google.gson.Gson
import com.google.gson.GsonBuilder

object GsonHolder {
    val gson: Gson by lazy { GsonBuilder()
        .serializeSpecialFloatingPointValues()
        .disableHtmlEscaping()
        .create() }
}

fun Event.format(): CharSequence? =
    GsonHolder.gson.toJson(this)

// actually same as above
fun Event.formatJSON(): CharSequence? =
    GsonHolder.gson.toJson(this)
