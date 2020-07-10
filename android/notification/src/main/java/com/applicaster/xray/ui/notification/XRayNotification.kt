package com.applicaster.xray.ui.notification

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import androidx.core.app.NotificationCompat

object XRayNotification {

    private const val CHANNEL_ID = "xray.notification"
    private val CHANNEL_NAME: CharSequence = "X Ray logging"

    private const val requestCode = 1

    private var currentNotificationId = -1
    private var channelCreated = false

    fun show(context: Context, notificationId: Int, actions: HashMap<String, PendingIntent>? = null) {
        if (-1 != currentNotificationId) {
            hide(context)
        }
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (!channelCreated) {
            // create android channel
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT
                )
                channel.enableLights(false)
                channel.enableVibration(false)
                channel.importance = NotificationManager.IMPORTANCE_MIN
                channel.setSound(null, null)
                channel.setShowBadge(false)
                channel.lockscreenVisibility = Notification.VISIBILITY_SECRET
                notificationManager.createNotificationChannel(channel)
            }
            channelCreated = true
        }

        val intent = Intent(context, NotificationReceiver::class.java)
            .setAction("com.applicaster.xray.show.ui")

        val pi = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_CANCEL_CURRENT
        )
        val notificationBuilder =
            NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_xray_notification)
                .setLargeIcon(
                    BitmapFactory.decodeResource(
                        context.resources,
                        R.drawable.ic_xray_notification
                    )
                )
                .setContentTitle("X-Ray logger")
                .setOnlyAlertOnce(true)
                .setContentIntent(pi)
                .setAutoCancel(false)
                .setShowWhen(false)
                .addAction(0, "Show", pi)
                .setSound(null)

        actions?.forEach {
            notificationBuilder.addAction(0, it.key, it.value)
        }

        notificationManager.notify(notificationId, notificationBuilder.build())
        currentNotificationId = notificationId
    }

    fun hide(context: Context) {
        if (-1 == currentNotificationId) {
            return
        }
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(currentNotificationId)
        currentNotificationId = -1
    }
}