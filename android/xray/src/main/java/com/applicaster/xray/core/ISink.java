package com.applicaster.xray.core;

import androidx.annotation.NonNull;

import com.applicaster.xray.core.Event;

public interface ISink {
    void log(@NonNull Event event);
}
