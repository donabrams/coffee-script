# sending
# ----------------

class Buffer
  constructor: ->
    @val = ""
  prepend: (s) ->
    @val = s + @val
    this

test "send works with primitives", ->
  tests = [0, 1,true, false, [], {}, "a"]
  for test in test
    fn = ->
      test send
        valueOf()
    eq test, fn()
    
test "send works inline", ->
  fn = ->
    "a".replace("a", "b") send .valueOf()
  eq "b", fn();  
  
test "send works with indents", ->
  fn = ->
    "a".replace("a", "b") send
      valueOf()
  eq "b", fn();
  
test "send operates on result of previous line if preceeded by an indent", ->
fn = ->
  "a".replace("a", "b")
    send
      valueOf()
eq "b", fn();ß

  
test "send returns the last value only", ->
  tests = [0, 1,true, [], {}, "a"]
  for test in test
    fn = ->
      test send
        valueOf()
        valueOf() is false
    eq false, fn()
    fn = ->
      test
        valueOf() is false
        valueOf()
    eq test, fn()
    fn = ->
      test send
        valueOf() send
          valueOf() is false
        valueOf()
    eq test, fn()
    
test "send works several levels deep", ->
  a = new Buffer
  fn = ->
    a send
      prepend "a" send
        prepend "a" send
          prepend "a" send
            prepend "a"
  eq 4, fn().val.length
  
test "send executes lines in order", ->
  a = new Buffer
  fn = ->
    a send
      prepend "a" send
        prepend "b" send
          prepend "c"
          prepend "d"
      prepend "e" send
        prepend "f"
  eq a, fn()
  eq "fedcba", a.val
  
test "send allows for trailing if and unless on messages", ->
  a = new Buffer
  fn = ->
    a send
      prepend "a" if true
        send
          prepend "b" if false
            send 
              prepend "c"
              prepend "d"
      prepend "e" unless false
        send
          prepend "f" unless true
  eq a, fn()
  eq "ea", a.val
  
test "send allows for trailing if and unless on the send block", ->
  a = new Buffer
  fn = ->
    a
      send if true
        prepend "a"
          send unless false
            prepend "b"
              send if false
                prepend "c"
                prepend "d"
        prepend "e"
          send unless true
            prepend "f"
  eq a, fn()
  eq "eba", a.val
  
test "send values can be used inside trailing if and unless statements", ->
  a = new Buffer
  fn = ->
    a send
      prepend "a" if val is ""
        send
          prepend "b" if val is ""
            send
              prepend "c"
              prepend "d"
      prepend "e" unless val is "ea"
        send
          prepend "f" unless val is "ea"
  eq a, fn()
  eq "ea", a.val
