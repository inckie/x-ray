package com.applicaster.xray.crashreporter

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

/*
  Dummy activity for cases when we need to send report outside some other activity context
 */
class SendActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Reporting.sendLogReport(this)
        finish()
    }

    companion object {

        private const val sendAction = "com.applicaster.xray.send"

        @JvmStatic
        fun getSendPendingIntent(context: Context) =
            PendingIntent.getActivity(
                context,
                0,
                Intent(context, SendActivity::class.java)
                    .setAction(sendAction),
                PendingIntent.FLAG_CANCEL_CURRENT
            )!!
    }

}
