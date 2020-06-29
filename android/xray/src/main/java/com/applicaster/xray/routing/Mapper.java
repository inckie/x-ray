package com.applicaster.xray.routing;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.applicaster.xray.Logger;
import com.applicaster.xray.sinks.ISink;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/*
  Maps loggers to sinks using rules. Not thread safe
 */
public class Mapper {

    // sinks Set is be backed up by original map owned by Core
    private final Set<String> sinks;
    // map Logger base name -> (sink name -> sink filter)
    private final Map<String, HashMap<String, ISinkFilter>> loggerMapping = new HashMap<>();

    public Mapper(HashMap<String, ISink> sinks) {
        this.sinks = sinks.keySet();
    }

    public void setFilter(@NonNull final String loggerName,
                          @NonNull final String sinkName,
                          @NonNull final ISinkFilter filter) {
        synchronized (loggerMapping) {
            HashMap<String, ISinkFilter> mappedSinks = loggerMapping.get(loggerName);
            if (null != mappedSinks) {
                mappedSinks.put(sinkName, filter);
                return;
            }
            loggerMapping.put(loggerName, new HashMap<String, ISinkFilter>() {{
                put(sinkName, filter);
            }});
        }
    }

    @Nullable
    private HashMap<String, ISinkFilter> getClosestMapping(@NonNull String logger) {
        if(logger.isEmpty()) {
            return loggerMapping.get(""); // root logger mapping
        }
        // exact match
        HashMap<String, ISinkFilter> mappedSinks = loggerMapping.get(logger);
        if(null != mappedSinks) {
            return mappedSinks;
        }
        // look for any parent mapping
        int i = logger.lastIndexOf(Logger.NameSeparator);
        while(i > 0) {
            String parent = logger.substring(0, i);
            mappedSinks = loggerMapping.get(parent);
            if(null != mappedSinks) {
                return mappedSinks;
            }
            logger = parent;
            i = logger.lastIndexOf(Logger.NameSeparator);
        }
        return loggerMapping.get(""); // root logger mapping
    }

    public Set<String> getMapping(@NonNull String logger,
                                  @NonNull String tag,
                                  int level) {
        HashSet<String> result;
        synchronized (sinks) {
            result = new HashSet<>(this.sinks);
        }
        HashMap<String, ISinkFilter> mappedSinks;
        synchronized (loggerMapping) {
            mappedSinks = getClosestMapping(logger);
        }
        if (mappedSinks == null) {
            return result;
        }
        for (Map.Entry<String, ISinkFilter> mappedSink : mappedSinks.entrySet()) {
            if (null != mappedSink.getValue() && !mappedSink.getValue().accept(logger, tag, level)) {
                result.remove(mappedSink.getKey());
            }
        }
        return result;
    }

    public boolean hasSinks(@NonNull String loggerName,
                            @NonNull String tag,
                            int level) {
        // todo: optimize
        return !getMapping(loggerName, tag, level).isEmpty();
    }
}
