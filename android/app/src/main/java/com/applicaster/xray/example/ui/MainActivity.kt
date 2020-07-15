package com.applicaster.xray.example.ui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import com.applicaster.xray.core.Core
import com.applicaster.xray.core.LogContext
import com.applicaster.xray.core.Logger
import com.applicaster.xray.android.contexts.ThreadContext
import com.applicaster.xray.android.routing.DefaultSinkFilter
import com.applicaster.xray.example.model.JavaTestClass
import com.applicaster.xray.example.model.KotlinTestClass
import com.applicaster.xray.example.R
import com.applicaster.xray.core.formatting.message.ReflectionMessageFormatter
import com.applicaster.xray.core.formatting.message.NamedReflectionMessageFormatter
import com.applicaster.xray.android.sinks.ADBSink
import com.applicaster.xray.android.sinks.PackageFileLogSink
import com.applicaster.xray.crashreporter.Reporting
import com.applicaster.xray.example.sinks.InMemoryLogSink

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {

        // check if we have already initialized x-ray
        if (null == Core.get().getSink("adb_sink")) {

            val fileLogSink =
                PackageFileLogSink(
                    this,
                    "default.log"
                );
            val errorFileLogSink =
                PackageFileLogSink(
                    this,
                    "errors.log"
                );

            // Here you can use fileLogSink.getFile() to connect log file to crash reporting module:
            Reporting.init("crash@example.com", fileLogSink.file)
            Reporting.enableForCurrentThread(this) // todo: combine with init?

            Core.get()
                .addSink("adb_sink", ADBSink())
                .addSink(
                    "memory_sink",
                    InMemoryLogSink()
                )
                .addSink("default_log_sink", fileLogSink)
                .addSink("error_log_sink", errorFileLogSink)
                .setFilter("error_log_sink", "", DefaultSinkFilter(Log.ERROR))

            val rootLogger = Logger.get()
            rootLogger.setContext(ThreadContext())
            rootLogger.setFormatter(ReflectionMessageFormatter())
        }

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<Button>(R.id.btn_log_some).setOnClickListener { logSomeEvents() }
        findViewById<Button>(R.id.btn_crash).setOnClickListener { throw Exception("Test crash") }

        // now when UI is ready, we can check for crash report
        Reporting.checkCrashReport(this)
    }

    private fun logSomeEvents() {
        val rootLogger = Logger.get()
        val kotlinTestClass = KotlinTestClass(
            "String field",
            0xff,
            0.1f
        )
        val javaTestClass = JavaTestClass(
            "String field",
            0xff,
            0.1f
        )

        rootLogger
            .d() // auto tag with enclosing class name
            .putData(mapOf("object" to kotlinTestClass))
            .message(
                "Formatter test for Kotlin class %s&object_contents",
                kotlinTestClass
            )

        rootLogger
            .d("Test")
            .message("Basic message")

        rootLogger
            .d() // auto tag with enclosing class name
            .putData(mapOf("object" to kotlinTestClass))
            .message(
                "Formatter test for Kotlin class %s",
                kotlinTestClass
            )

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Kotlin class %s",
                kotlinTestClass
            )

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Java class %s",
                javaTestClass
            )

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Java and Kotlin classes with positional args. Java: %1\$s, Kotlin: %2\$s",
                javaTestClass,
                kotlinTestClass
            )

        // create a child logger
        val childLogger = rootLogger.getChild("childLogger");

        // configure child logger: set custom formatter and append context
        childLogger
            .setFormatter(NamedReflectionMessageFormatter()) // this will extract log arguments as a named key value pairs to the event
            .setContext(LogContext(mapOf("loggerContext" to "loggerContextValue")));

        Core.get()
            .setFilter("error_log_sink", "childLogger", DLogefaultSinkFilter(.DEBUG))

        rootLogger
            .d("Test")
            .withCallStack()
            .message(
                "Logging debug to root"
            )

        rootLogger
            .e("Test")
            .withCallStack()
            .message(
                "Logging error to root"
            )

        childLogger
            .d("Test")
            .withCallStack()
            .message(
                "Logging debug to child"
            )

        childLogger
            .e("Test")
            .withCallStack()
            .message(
                "Logging error to child"
            )

        // use child logger
        childLogger
            .d("Test")
            .withCallStack()
            .message(
                "Formatter test for Java and Kotlin classes with extracted positional args. Java: %1\$s&java_object, Kotlin: %2\$s&kotlin_object",
                javaTestClass,
                kotlinTestClass
            )
    }
}
