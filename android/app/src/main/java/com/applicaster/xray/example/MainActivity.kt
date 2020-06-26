package com.applicaster.xray.example

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import com.applicaster.xray.Core
import com.applicaster.xray.LogContext
import com.applicaster.xray.Logger
import com.applicaster.xray.formatting.message.ReflectionMessageFormatter
import com.applicaster.xray.formatting.message.NamedReflectionMessageFormatter
import com.applicaster.xray.sinks.android.ADBSink
import com.applicaster.xray.sinks.android.FileLogSink

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {

        val fileLogSink = FileLogSink(this, "default.log");
        // Here you can use fileLogSink.getFile() to connect log file to crash reporting module:
        // CrashReporter.setLogFile(fileLogSink.getFile());
        // most likely you'll need to implement content provider to pass the file to share intent

        Core.get()
            .addSink("adb_sink", ADBSink())
            .addSink("default_log_sink", fileLogSink)

        val rootLogger = Logger.get();
        rootLogger.setFormatter(ReflectionMessageFormatter())

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<Button>(R.id.button)?.setOnClickListener {
            Toast.makeText(this, "Connect the debugger", Toast.LENGTH_SHORT).show()
            android.os.Debug.waitForDebugger()
            Toast.makeText(this, "Debugger is connected", Toast.LENGTH_SHORT).show()
            Log.i("Logger", "connected")
        }

        val kotlinTestClass = KotlinTestClass("String field", 0xff, 0.1f)
        val javaTestClass = JavaTestClass("String field", 0xff, 0.1f)

        rootLogger
            .d() // auto tag with enclosing class name
            .putData(mapOf("object" to kotlinTestClass))
            .message(
                "Formatter test for Kotlin class %s&object_contents",
                kotlinTestClass)

        rootLogger
            .d("Test")
            .message("Basic message")

        rootLogger
            .d() // auto tag with enclosing class name
            .putData(mapOf("object" to kotlinTestClass))
            .message(
                "Formatter test for Kotlin class %s",
                kotlinTestClass)

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Kotlin class %s",
                kotlinTestClass)

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Java class %s",
                javaTestClass)

        rootLogger
            .d("Test")
            .message(
                "Formatter test for Java and Kotlin classes with positional args. Java: %1\$s, Kotlin: %2\$s",
                javaTestClass,
                kotlinTestClass)

        // create a child logger
        val childLogger = rootLogger.getChild("childLogger");

        // configure child logger: set custom formatter and append context
        childLogger
            .setFormatter(NamedReflectionMessageFormatter()) // this will extract log arguments as a named key value pairs to the event
            .setContext(LogContext(mapOf("loggerContext" to "loggerContextValue")));

        // use child logger
        childLogger
            .d("Test")
            .withCallStack()
            .message(
                "Formatter test for Java and Kotlin classes with extracted positional args. Java: %1\$s&java_object, Kotlin: %2\$s&kotlin_object",
                javaTestClass,
                kotlinTestClass)
    }
}
