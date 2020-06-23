package com.applicaster.xray;

import androidx.annotation.NonNull;

import com.applicaster.xray.sinks.ISink;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/*
  Maps loggers to sinks using rules. Not thread safe
 */
public class Mapper {

    // sinks
    private final HashMap<String, ISink> sinks;
    private final Map<String, ArrayList<ISink>> loggerMapping = new HashMap<>();

    // enable-disable filters
    // todo

    public Mapper(HashMap<String, ISink> sinks) {
        this.sinks = sinks;
    }

    public ArrayList<ISink> getMapping(@NonNull Logger logger,
                                       @NonNull Event event) {
        ArrayList<ISink> mappedSinks = loggerMapping.get(logger.getName());
        if (mappedSinks == null) {
            return filter(this.sinks.values(), event);
        }
        return filter(mappedSinks, event);
    }

    private ArrayList<ISink> filter(@NonNull Collection<ISink> mappedSinks,
                                    @NonNull Event event) {
        // todo: missing layer of mapping by event data
        // avoid returning original array for threading sake
        return new ArrayList<>(mappedSinks);
    }

    public boolean isEnabled(@NonNull Logger logger) {
        return true;
    }
}
