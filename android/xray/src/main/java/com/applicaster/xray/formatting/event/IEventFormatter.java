package com.applicaster.xray.formatting.event;

import androidx.annotation.NonNull;

import com.applicaster.xray.Event;

public interface IEventFormatter {
    @NonNull
    String format(@NonNull Event event);
}
