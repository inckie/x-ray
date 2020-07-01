package com.applicaster.xray.core.formatting.event;

import androidx.annotation.NonNull;

import com.applicaster.xray.core.Event;

public class PlainTextEventFormatter implements IEventFormatter {

    // todo: set format string (ADB Sink does not need tag or time)

    @NonNull
    @Override
    public String format(@NonNull Event event) {
        StringBuilder sb = new StringBuilder(event.getMessage());
        if(null != event.getData()) {
            sb.append("\n\tdata: " ).append(event.getData());
        }
        if(null != event.getContext()) {
            sb.append("\n\tcontext: " ).append(event.getContext());
        }
        return sb.toString();
    }
}
