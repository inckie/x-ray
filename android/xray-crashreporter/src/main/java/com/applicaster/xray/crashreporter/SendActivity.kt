package com.applicaster.xray.crashreporter

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import java.io.File

/*
  Dummy activity for cases when we need to send report outside some other activity context
 */
class SendActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val fileName = intent.extras?.getString(fileExtra)
        if(fileName.isNullOrEmpty()) {
            Reporting.sendLogReport(this)
        }
        else {
            Reporting.sendLogReport(this, File(fileName))
        }
        finish()
    }

    companion object {

        private val intentFlag = when {
            Build.VERSION.SDK_INT < Build.VERSION_CODES.S -> PendingIntent.FLAG_CANCEL_CURRENT
            else -> PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_CANCEL_CURRENT
        }

        private const val sendAction = "com.applicaster.xray.send"
        private const val fileExtra = "attachment_filename"

        @JvmStatic
        fun getSendPendingIntent(context: Context) =
            PendingIntent.getActivity(
                context,
                0,
                Intent(context, SendActivity::class.java)
                    .setAction(sendAction),
                intentFlag
            )!!

        @JvmStatic
        fun getSendPendingIntent(context: Context, fileName: String) =
            PendingIntent.getActivity(
                context,
                0,
                Intent(context, SendActivity::class.java)
                    .setAction(sendAction)
                    .putExtra(fileExtra, fileName),
                intentFlag
            )!!
    }

}
