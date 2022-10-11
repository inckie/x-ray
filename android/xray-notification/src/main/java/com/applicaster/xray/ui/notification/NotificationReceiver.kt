package com.applicaster.xray.ui.notification

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

/**
 * Dummy class to receive intents that are not handled by anyone else.
 * Can be used later to handle some additional internal actions.
 */
class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("NotificationReceiver", "Intent action " + intent.action)
    }

    companion object {
        private const val requestCode = 1
        private val intentFlag = when {
            Build.VERSION.SDK_INT < Build.VERSION_CODES.S -> PendingIntent.FLAG_CANCEL_CURRENT
            else -> PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
        }

        fun getIntent(context: Context?, action: String?): PendingIntent =
            PendingIntent.getBroadcast(
                context,
                requestCode,
                Intent(context, NotificationReceiver::class.java).setAction(action),
                intentFlag
            )
    }
}