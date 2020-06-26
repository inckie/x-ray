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


public class EventBuilder implements IEventBuilder {
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

    @Override
    public Event build() {
        // todo: handle expandData
        return new Event(tag, logger.getName(), timestamp.getTime(), level, message, data, context);
    }

    @Override
    @NotNull
    public IEventBuilder setLevel(int level) {
        this.level = level;
        return this;
    }

    @Override
    @NotNull
    public IEventBuilder putData(@NotNull Map<String, ?> data) {
        this.data.putAll(data);
        return this;
    }

    // Expand data to primitive classes. toString will be used otherwise
    @Override
    @NonNull
    public IEventBuilder expandData() {
        this.expandData = true;
        return this;
    }

    @Override
    public void message(@NonNull String message) {
        this.message = message;
        submit();
    }

    @Override
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

    @Override
    @NotNull
    public IEventBuilder withCallStack() {
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
