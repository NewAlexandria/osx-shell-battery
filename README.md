# Shell Battery functions for OSX

A small lib of Bash utilities for accessing the battery information.

These typically may be integrated into the command prompt, with something like

```
export PS1="[\$(__batt_pct)]\$(__batt_time) [\$(__batt_state)] [\d \t] "
```

## Testing

These have been tested on OSX 10.14 Mojave.  If you find they work on other OSs, please let me know!

## License

MIT.
