package com.applicaster.xray.crashreporter

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
}
