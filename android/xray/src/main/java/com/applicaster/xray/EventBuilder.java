package com.applicaster.xray;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.applicaster.xray.utility.Stack;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// ToDo: must be abstract so we can return dummy
public class EventBuilder {
    private final Logger logger;
    private final String tag;
    private final Date timestamp;
    private final LogContext context;
    private LinkedHashMap<String, Object> data = new LinkedHashMap<>();
    private int level;
    private String message;
    private boolean expandData; // todo: covert objects to Map/Array or other convenient container if set

    private boolean submitted;

    public EventBuilder(@NonNull Logger logger,
                        @NonNull String tag,
                        @NonNull LogContext context) {
        this.tag = tag;
        this.logger = logger;
        this.timestamp = new Date();
        this.context = context;
    }

    public Event build() {
        // todo: handle expandData
        return new Event(tag, timestamp, level, message, data, context);
    }

    public EventBuilder setLevel(int level) {
        this.level = level;
        return this;
    }

    @NotNull
    public EventBuilder putData(@NotNull Map<String, ?> data) {
        this.data.putAll(data);
        return this;
    }

    // Expand data to primitive classes. toString will be used otherwise
    @NonNull
    public EventBuilder expandData() {
        this.expandData = true;
        return this;
    }

    public void message(@NonNull String message) {
        this.message = message;
        submit();
    }

    public void message(@NonNull String message,
                        @Nullable Object... args) {
        this.message = logger.getFormattedMessage(message, data, args);
        submit();
    }

    private void submit() {
        logger.submit(build());
        submitted = true;
    }

    private void internalError(@NonNull String message) {

    }

    @NotNull
    public EventBuilder withCallStack() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        int frameOffset = Stack.getClientCodeFrameOffset(stackTrace);
        List<String> stack = new ArrayList<>();
        for (int i = frameOffset; i < stackTrace.length; i++) {
            StackTraceElement stackTraceElement = stackTrace[i];
            stack.add(stackTraceElement.toString() + '\n');
        }
        context.put("stackTrace", stack);
        return this;
    }

}
