package com.applicaster.xray.routing;

import androidx.annotation.NonNull;

public interface ISinkFilter {
    boolean accept(@NonNull String loggerName, @NonNull String tag, int level);
}
