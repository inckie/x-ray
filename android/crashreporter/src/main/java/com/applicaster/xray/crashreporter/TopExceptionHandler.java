package com.applicaster.xray.crashreporter;

import android.content.Context;

import androidx.annotation.NonNull;

import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.Thread.UncaughtExceptionHandler;

public class TopExceptionHandler implements UncaughtExceptionHandler {

    public static final String STACK_TRACE_FILE = "stack.trace";

    private Thread.UncaughtExceptionHandler defaultUEH;

    private final Context context;

    public TopExceptionHandler(Context ctx) {
        this.defaultUEH = Thread.getDefaultUncaughtExceptionHandler();
        this.context = ctx.getApplicationContext();
    }

    public void uncaughtException(@NonNull Thread t, Throwable e) {
        StackTraceElement[] arr = e.getStackTrace();
        StringBuilder report = new StringBuilder(e.toString() + "\n\n");
        report.append("--------- Stack trace ---------\n\n");
        for (StackTraceElement anArr : arr)
            report.append("    ").append(anArr.toString()).append("\n");
        report.append("-------------------------------\n\n");

        report.append("--------- Cause ---------\n\n");
        Throwable cause = e.getCause();
        if (cause != null) {
            report.append(cause.toString()).append("\n\n");
            arr = cause.getStackTrace();
            for (StackTraceElement anArr : arr)
                report.append("    ").append(anArr.toString()).append("\n");
        }
        report.append("-------------------------------\n\n");

        try(FileOutputStream trace = context.openFileOutput(STACK_TRACE_FILE, Context.MODE_PRIVATE)) {
            trace.write(report.toString().getBytes());
        } catch (IOException ioe) {
            // ignored
        }
        defaultUEH.uncaughtException(t, e);
    }

}
