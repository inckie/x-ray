# General Purpose Logger

## Features:
- Sinks as in serilog: ADB, file, etc.
- Deep object dump support with moshi

# To Do:
- Mapper configuration
- Make EventBuilder abstract so we can return dummy if log will not be recorded to save performance
- Event formatters with time, tag, etc placeholders
- Named placeholders in templates (WIP)
- Split the source code to modules or source sets. Better both as an option.

## Issues:
- Using Android-specific nullable annotations
- Uses Kotlin internally
