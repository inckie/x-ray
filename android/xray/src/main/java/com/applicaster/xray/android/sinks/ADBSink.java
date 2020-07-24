package com.applicaster.xray.android.sinks;

import android.util.Log;

import androidx.annotation.NonNull;

import com.applicaster.xray.core.Event;
import com.applicaster.xray.core.ISink;
import com.applicaster.xray.core.LogLevel;
import com.applicaster.xray.core.formatting.event.IEventFormatter;
import com.applicaster.xray.core.formatting.event.PlainTextEventFormatter;

/*
 Very basic adb output sink
 */
public class ADBSink implements ISink {

    private final IEventFormatter formatter = new PlainTextEventFormatter();

    @Override
    public void log(@NonNull Event event) {
        if(LogLevel.error.level == event.getLevel() && null != event.getException()) {
            Log.e(event.getCategory(), formatter.format(event), event.getException());
        } else {
            Log.println(mapLevel(event.getLevel()), event.getCategory(), formatter.format(event));
        }
    }

    private static int mapLevel(int level) {
        return Log.VERBOSE + level; // On x-ray, verbose is 0. On Android, is 2
    }

}
