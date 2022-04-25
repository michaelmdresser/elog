// The core log effect: take a level and string, and do something.
effect fun log( level : int, msg : string ) : ()


// Convert an integer log level to a string for human-readability. Koka may have
// a better way of doing this, but I'm new to the language.
fun level-to-string(level: int): string
  match level
    0 -> "ERROR"
    1 -> "WARNING"
    2 -> "INFO"
    3 -> "DEBUG"
    _ -> "UNKNOWN LEVEL"


// A handler for log() that only prints the message if the level is <= the target
// level.
fun log-leveled(target-level : int, action)
  with fun log(level, msg) {
    if level <= target-level then
      println(level-to-string(level) ++ ":" ++ msg)
  }

  action()


// An arbitrary function called by the "HTTP handler". This function doesn't
// define its own log handler -- it relies on the "HTTP handler" to decide the
// log level and set the effect handler for log() appropriately.
fun http-handler-logic(foo: string, bar: string)
  log(0, "test error level")
  log(1, "test warning level")
  log(2, "FOO:" ++ foo)
  log(3, "BAR:" ++ bar)

  return foo ++ "_" ++ bar


// The "HTTP handler" which sets the log() effect handler at the appropriate
// level based on the verbose flag, and then calls its logic.
fun http-handler( custom-arg: string, verbose : bool )
  var log-level := 2
  if verbose then {
    log-level := 3
  }
  with log-leveled(log-level)

  return http-handler-logic(custom-arg, "testbar")


fun main()
  println("++Simulating a handler call with verbose=false")
  http-handler("custom-arg-1", False)
  println("++Done")

  println("")

  println("++Simulating a handler call with verbose=true")
  http-handler("custom-arg-2", True)
  println("++Done")
