package com.applicaster.xray;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.applicaster.xray.formatting.message.IMessageFormatter;
import com.applicaster.xray.formatting.message.BasicMessageFormatter;
import com.applicaster.xray.sinks.ISink;
import com.applicaster.xray.utility.Stack;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Logger {

    private final HashMap<String, Logger> children = new HashMap<>();
    private final String name;
    private final Logger parent;
    private LogContext context = new LogContext();
    private IMessageFormatter messageFormatter = new BasicMessageFormatter();

    private static final Logger sRoot = new Logger("", null);

    // todo: fail, info, warn levels

    public IEventBuilder d() {
        return d(getStackTag());
    }

    public IEventBuilder e() {
        return e(getStackTag());
    }

    public IEventBuilder d(@NonNull String tag) {
        return makeBuilder(tag, Log.DEBUG);
    }

    public IEventBuilder e(@NonNull String tag) {
        return makeBuilder(tag, Log.ERROR);
    }

    @NotNull
    private IEventBuilder makeBuilder(@NonNull String tag, int level) {
        if(!Core.get().hasSinks(tag, level, this)) {
            return new NullEventBuilder();
        }
        return new EventBuilder(this, tag, getFullContext())
                .setLevel(level);
    }

    @NotNull
    public synchronized Map<String, Object> getFullContext() {
        Map<String, Object> mergedContext = new HashMap<>();
        if (parent != null) {
            mergedContext.putAll(parent.getFullContext());
        }
        // override parent values on conflict
        mergedContext.putAll(context.retrieve());
        return mergedContext;
    }

    @NotNull
    public synchronized Logger setContext(@NotNull LogContext context) {
        this.context = context; // overrides context!
        return this;
    }

    void submit(Event event) {
        // todo: this should be extracted since logger is not the only source of Events
        ArrayList<ISink> mapping = Core.get().getMapping(this, event);
        if(!mapping.isEmpty()) {
            for(ISink sink : mapping)
                sink.log(event);
        }
    }

    @NonNull
    private String getStackTag() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        int frameOffset = Stack.getClientCodeFrameOffset(stackTrace);
        if(frameOffset >= 0 && frameOffset < stackTrace.length) {
            return stackTrace[frameOffset].getClassName();
        }
        return "Undefined";
    }

    private Logger(@NonNull String name,
                   @Nullable Logger parent) {
        this.name = name;
        this.parent = parent;
    }

    @NotNull
    public static synchronized Logger get() {
        return sRoot;
    }

    @NotNull
    public synchronized Logger getChild(@NonNull String childName) {
        Logger logger = children.get(childName);
        if(null != logger) {
            return logger;
        }
        logger = new Logger(name + "." + childName, null);
        // todo: decide what to copy to the child: formatter?
        logger.messageFormatter = this.messageFormatter;
        children.put(childName, logger);
        return logger;
    }

    public static synchronized Logger get(@NonNull String name){
        return sRoot.getChild(name);
    }

    public String getName() {
        return name;
    }

    @NonNull
    public String getFormattedMessage(String template, Map<String, Object> outParameters, Object... args) {
        return messageFormatter.format(template, outParameters, args);
    }

    public Logger setFormatter(@NotNull IMessageFormatter formatter) {
        this.messageFormatter = formatter;
        return this;
    }

}
