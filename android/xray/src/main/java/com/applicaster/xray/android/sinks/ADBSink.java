package com.applicaster.xray.android.sinks;

import android.util.Log;

import androidx.annotation.NonNull;

import com.applicaster.xray.Event;
import com.applicaster.xray.formatting.event.IEventFormatter;
import com.applicaster.xray.formatting.event.PlainTextEventFormatter;
import com.applicaster.xray.sinks.ISink;

/*
 Very basic adb output sink
 */
public class ADBSink implements ISink {

    private final IEventFormatter formatter = new PlainTextEventFormatter();

    @Override
    public void log(@NonNull Event event) {
        Log.println(event.getLevel(), event.getTag(), formatter.format(event));
    }

}
