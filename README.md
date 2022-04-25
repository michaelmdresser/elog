# elog: testing context-variable log level using Koka effects

> I turned this into a small [blog post](https://blog.michaeldresser.io/posts/2022-04-24_context-variable-log-level-koka-effects.html)

I stumbled upon the [Koka](https://koka-lang.github.io/koka/doc/index.html)
language recently and, after a conversation about effects, was inspired to try
using it to make the log level of a call stack dynamic based on an argument.

I find this potentially valuable because there are times in my day-to-day work
writing HTTP handlers when I wish I could turn on DEBUG-level logging for just
_one_ call. Then I could see the granularity of logging I desire in the desired
context without forcing a user to restart the application (to set a new log
level) and wade through a sea of irrelevant DEBUG-level logs (from other parts
of the application).

By using Koka's effects, I can set a log level at the handler level, and then
all of the logic in the handler (and called by the handler) inherits that log
level -- I don't have to pass a variable like `verbose` or `log-level`
throughout.

## Results

Run `koka -e elog.kk`:
```
++Simulating a handler call with verbose=false
ERROR:test error level
WARNING:test warning level
INFO:FOO:custom-arg-1
++Done

++Simulating a handler call with verbose=true
ERROR:test error level
WARNING:test warning level
INFO:FOO:custom-arg-2
DEBUG:BAR:testbar
++Done
```
