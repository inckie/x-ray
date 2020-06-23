package com.applicaster.xray

import java.util.*

class LogContext() : HashMap<String, Any?>(){
    constructor(logContext: LogContext) : this() {
        this.putAll(logContext)
    }

    constructor(logContext: Map<String, Any?>): this() {
        this.putAll(logContext)
    }
}