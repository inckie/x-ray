package com.applicaster.xray;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.jetbrains.annotations.NotNull;

import java.util.Map;

public interface IEventBuilder {

    Event build(); // todo: think what dummy EventBuilder will do. Can it be null?

    @NotNull
    IEventBuilder setLevel(int level);

    @NotNull
    IEventBuilder putData(@NotNull Map<String, ?> data);

    // Expand data to primitive classes. toString will be used otherwise
    @NonNull
    IEventBuilder expandData();

    @NotNull
    IEventBuilder withCallStack();

    void message(@NonNull String message);

    void message(@NonNull String message,
                 @Nullable Object... args);

}
