system should be like a drive. Subsystems are folders inside. Root is a special place (“my pc” on windows, on linux there is no forests in FS).
So we go up from current directory looking for filter rules files, and apply them. Rules file names match sinks names, so we need to go up for every known sink and look for corresponding file. If not found, that means ‘always allowed’.
Filter file can override any behavior in any direction, no merge conflict
