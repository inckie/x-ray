# General Purpose Logger

## Features:
- Sinks as in serilog: ADB, file, etc.
- Deep object dump support with moshi

# To Do:
- Dynamic Context Providers in loggers (thread, etc)
- Mapper configuration
- Use Dummy EventBuilder if log event will not be recorded to save performance
- Event formatters with time, tag, etc placeholders
- Named placeholders in templates (WIP)
- Split the source code to modules or source sets. Better both as an option.
- In-memory circular buffer event sink
- Maybe output file sinks to cache and not data storage, so user can wipe it without losing data
- Trim/rotate file sinks

## Issues:
- Using Android-specific nullable annotations
- Uses Kotlin internally
