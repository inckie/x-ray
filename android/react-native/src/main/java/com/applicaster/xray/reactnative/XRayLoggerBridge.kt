package com.applicaster.xray.reactnative

import com.applicaster.xray.core.Core
import com.applicaster.xray.core.Event
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap

class XRayLoggerBridge(reactContext: ReactApplicationContext)
    : ReactContextBaseJavaModule(reactContext) {

    companion object {
        private const val NAME = "XRayLoggerBridge"
    }

    override fun getName(): String {
        return NAME
    }

    @ReactMethod
    fun logEvent(eventData: ReadableMap) {
        val tag = eventData.getString("category")!!
        val logger = eventData.getString("subsystem")!!
        val level = eventData.getInt("level")
        if(!Core.get().hasSinks(tag, logger, level)) {
            return
        }
        val event = Event(
            tag,
            logger,
            System.currentTimeMillis(),
            level,
            eventData.getString("message")!!,
            eventData.getMap("data")?.toHashMap(),
            eventData.getMap("context")?.toHashMap(),
            null
        )
        // todo: this should be extracted since this code is shared with logger
        val mapping = Core.get().getMapping(event)
        if (mapping.isNotEmpty()) {
            for (sink in mapping) sink.log(event)
        }
    }

}