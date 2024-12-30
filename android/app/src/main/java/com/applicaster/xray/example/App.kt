package com.applicaster.xray.example

import android.app.Application
import com.applicaster.xray.android.contexts.ThreadContext
import com.applicaster.xray.android.routing.DefaultSinkFilter
import com.applicaster.xray.android.sinks.ADBSink
import com.applicaster.xray.android.sinks.PackageFileLogSink
import com.applicaster.xray.core.Core
import com.applicaster.xray.core.LogLevel
import com.applicaster.xray.core.Logger
import com.applicaster.xray.crashreporter.Reporting
import com.applicaster.xray.example.sinks.ElasticSink
import com.applicaster.xray.formatters.message.reflactionformatter.ReflectionMessageFormatter
import com.applicaster.xray.ui.sinks.InMemoryLogSink

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        initXRay()
    }

    companion object {
        const val memory_sink_name = "memory_sink" // used in EventLogFragment sink_name field
        private const val enableElastic = false
    }

    private fun initXRay() {

        val fileLogSink =
            PackageFileLogSink(
                this,
                "default.log",
                256 * 1024
            )
        val errorFileLogSink =
            PackageFileLogSink(
                this,
                "errors.log"
            )

        // Here you can use fileLogSink.getFile() to connect log file to crash reporting module:
        // Its also possible to provide file name to the SendActivity intent directly
        Reporting.init("crash@example.com", fileLogSink.file)
        Reporting.enableForCurrentThread(this, true)

        Core.get()
            .addSink("adb_sink", ADBSink())
            .addSink(
                memory_sink_name,
                InMemoryLogSink()
            )
            .addSink("default_log_sink", fileLogSink)
            .addSink("error_log_sink", errorFileLogSink)
            .setFilter("error_log_sink", "", DefaultSinkFilter(LogLevel.error))

        if(enableElastic)
            Core.get().addSink("elastic", ElasticSink())

        val rootLogger = Logger.get()
        rootLogger.setContext(ThreadContext())
        rootLogger.setFormatter(ReflectionMessageFormatter())
    }

}