package com.applicaster.xray.android.routing;

import android.util.Log;

import androidx.annotation.NonNull;

import com.applicaster.xray.routing.ISinkFilter;

public class DefaultSinkFilter implements ISinkFilter {

    private int minLevel = Log.DEBUG;

    public DefaultSinkFilter(int level) {
        minLevel = level;
    }

    @Override
    public boolean accept(@NonNull String loggerName, @NonNull String tag, int level) {
        return minLevel <= level;
    }
}
