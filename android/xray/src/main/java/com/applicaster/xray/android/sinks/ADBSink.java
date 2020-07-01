package com.applicaster.xray.android.sinks;

import android.util.Log;

import androidx.annotation.NonNull;

import com.applicaster.xray.core.Event;
import com.applicaster.xray.core.formatting.event.IEventFormatter;
import com.applicaster.xray.core.formatting.event.PlainTextEventFormatter;
import com.applicaster.xray.core.ISink;

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
