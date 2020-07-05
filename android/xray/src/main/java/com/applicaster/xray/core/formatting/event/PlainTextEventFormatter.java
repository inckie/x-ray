package com.applicaster.xray.core.formatting.event;

import androidx.annotation.NonNull;

import com.applicaster.xray.core.Event;

import java.util.Map;

public class PlainTextEventFormatter implements IEventFormatter {

    // todo: set format string (ADB Sink does not need tag or time)

    @NonNull
    @Override
    public String format(@NonNull Event event) {
        StringBuilder sb = new StringBuilder(event.getMessage()).append("\n");
        Map<String, Object> data = event.getData();
        if(null != data && !data.isEmpty()) {
            sb.append("\n\tdata: ").append(data).append("\n");
        }
        Map<String, Object> context = event.getContext();
        if(null != context && !context.isEmpty()) {
            sb.append("\n\tcontext: ").append(context).append("\n");
        }
        return sb.toString();
    }
}
