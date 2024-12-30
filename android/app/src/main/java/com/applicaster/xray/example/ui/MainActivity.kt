package com.applicaster.xray.example.ui

import android.Manifest
import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.applicaster.xray.android.routing.DefaultSinkFilter
import com.applicaster.xray.core.Core
import com.applicaster.xray.core.LogContext
import com.applicaster.xray.core.LogLevel
import com.applicaster.xray.core.Logger
import com.applicaster.xray.crashreporter.Reporting
import com.applicaster.xray.crashreporter.SendActivity
import com.applicaster.xray.example.R
import com.applicaster.xray.example.model.JavaTestClass
import com.applicaster.xray.example.model.KotlinTestClass
import com.applicaster.xray.formatters.message.reflactionformatter.NamedReflectionMessageFormatter
import com.applicaster.xray.ui.notification.XRayNotification

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<Button>(R.id.btn_log_some).setOnClickListener { logSomeEvents() }
        findViewById<Button>(R.id.btn_crash).setOnClickListener { throw Exception("Test crash") }
        // now when UI is ready, we can check for crash report
        Reporting.checkCrashReport(this)

        if (requestNotificationPermission()) {
            initXRayNotification()
        }
    }

    @SuppressLint("InlinedApi")
    private fun requestNotificationPermission(): Boolean {
        if (hasNotificationPermission()) {
            return true
        }
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), NOTIFICATIONS_PERMISSION_REQUEST_CODE)
        return false
    }

    private fun hasNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) ==
                PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == NOTIFICATIONS_PERMISSION_REQUEST_CODE) {
            if (hasNotificationPermission()) {
                initXRayNotification()
            } else {
                Log.e(TAG, "Notification permission not granted")
            }
        }
    }

    private fun initXRayNotification() {
        // configure XRay notification

        // add log view and report sharing buttons

        val intentFlag = when {
            Build.VERSION.SDK_INT < Build.VERSION_CODES.S -> PendingIntent.FLAG_CANCEL_CURRENT
            else -> PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
        }

        val shareLogIntent = SendActivity.getSendPendingIntent(this)
        val showLogIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java)
                .setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_CLEAR_TASK),
            intentFlag
        )!!

        // actions order is kept in the UI
        val actions: HashMap<String, PendingIntent> = linkedMapOf(
            "Send" to shareLogIntent,
            "Show" to showLogIntent
        )

        // here we show Notification UI with custom actions
        XRayNotification.show(
            this,
            101,
            null,
            actions
        )
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
            .d("Test")
            .message("Basic debug message")

        rootLogger
            .i("Test")
            .message("Basic info message")

        rootLogger
            .w("Test")
            .message("Basic warning message")

        rootLogger
            .e("Test")
            .exception(Exception("Error", Exception("Cause")))
            .message("Basic error message")

        rootLogger
            .d() // auto tag with enclosing class name
            .putData(mapOf("object" to kotlinTestClass))
            .message(
                "Formatter test for Kotlin class %s&object_contents",
                kotlinTestClass
            )

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
            .setFilter("error_log_sink", "childLogger", DefaultSinkFilter(LogLevel.debug))

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

    companion object {
        private const val TAG = "MainActivity"
        private const val NOTIFICATIONS_PERMISSION_REQUEST_CODE = 100
    }
}
