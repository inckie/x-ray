package com.applicaster.xray;

import androidx.annotation.NonNull;

import com.applicaster.xray.sinks.ISink;

import java.util.ArrayList;
import java.util.LinkedHashMap;

public class Core {

    private static Core instance;
    // LinkedHashMap retains key order
    private final LinkedHashMap<String, ISink> sinks = new LinkedHashMap<>();

    private final Mapper mapper = new Mapper(sinks);

    public Core addSink(String name, ISink sink) {
        synchronized(sinks) {
            sinks.put(name, sink);
        }
        return this;
    }

    @NonNull
    public static Core get() {
        if (null == instance) {
            synchronized (Core.class) {
                if (null == instance) {
                    instance = new Core();
                }
            }
        }
        return instance;
    }

    @NonNull
    public ArrayList<ISink> getMapping(@NonNull Logger logger,
                                       @NonNull Event event) {
        synchronized (mapper) {
            return mapper.getMapping(logger, event);
        }
    }
}
