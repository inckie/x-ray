package com.applicaster.xray.sinks;

import androidx.annotation.NonNull;

import com.applicaster.xray.Event;

public interface ISink {
    void log(@NonNull Event event);
}
