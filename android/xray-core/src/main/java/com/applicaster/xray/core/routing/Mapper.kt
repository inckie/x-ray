package com.applicaster.xray.core.routing

import com.applicaster.xray.core.ISink
import com.applicaster.xray.core.Logger

/*
 Maps loggers to sinks using rules. Not thread safe
*/
class Mapper(private val sinks: Map<String, ISink?>) {

    // map Logger subsystem -> (sink identifier -> sink filter)
    private val loggerMapping: MutableMap<String, MutableMap<String, ISinkFilter?>> = mutableMapOf()

    fun setFilter(
        loggerName: String,
        sinkName: String,
        filter: ISinkFilter?
    ) {
        synchronized(loggerMapping) {
            val mappedSinks = loggerMapping[loggerName]
            if (null != mappedSinks) {
                if (null != filter) {
                    mappedSinks[sinkName] = filter
                } else {
                    mappedSinks.remove(sinkName)
                    if (mappedSinks.isEmpty()) {
                        loggerMapping.remove(loggerName)
                    }
                }
                return
            }
            if (null == filter) {
                return
            }
            loggerMapping.put(loggerName, mutableMapOf(sinkName to filter))
        }
    }

    private fun getClosestMapping(logger: String): Map<String, ISinkFilter?>? {
        if (logger.isEmpty()) {
            return loggerMapping[""] // root logger mapping
        }
        // exact match
        var mappedSinks = loggerMapping[logger]
        if (null != mappedSinks) {
            // should not be empty
            return mappedSinks
        }
        // look for any parent mapping
        var i = logger.lastIndexOf(Logger.NameSeparator)
        var parent = logger
        while (i > 0) {
            parent = parent.substring(0, i)
            mappedSinks = loggerMapping[parent]
            if (null != mappedSinks) {
                return mappedSinks
            }
            i = parent.lastIndexOf(Logger.NameSeparator)
        }
        return loggerMapping[""] // root logger mapping
    }

    fun getMapping(
        logger: String,
        tag: String,
        level: Int
    ): Set<String> {
        val result = synchronized(sinks) {
            HashSet(this.sinks.keys)
        }
        val mappedSinks = synchronized(loggerMapping) {
            getClosestMapping(logger)
        }
        if (mappedSinks == null) {
            return result
        }
        for ((key, value) in mappedSinks) {
            if (null != value && !value.accept(logger, tag, level)) {
                result.remove(key)
            }
        }
        return result
    }

    fun hasSinks(
        loggerName: String,
        tag: String,
        level: Int
    ): Boolean {
        // todo: optimize
        return getMapping(loggerName, tag, level).isNotEmpty()
    }

    fun reset() {
        synchronized(loggerMapping) {
            loggerMapping.clear()
        }
    }
}
