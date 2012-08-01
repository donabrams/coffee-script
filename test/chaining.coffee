# Chaining
# ----------------

class Buffer
  constructor: ->
    @val = ""
  prepend: (s) ->
    @val = s + @val
    this

test "chaining works with primitives", ->
  tests = [0, 1,true, false, [], {}, "a"]
  for test in test
    fn = ->
      test
        \.valueOf()
    eq test, fn()
    
test "chaining operates on result of parent line", ->
  fn = ->
    "a".replace("a", "b")
      \.valueOf()
  eq "b", fn();

test "chaining works with both function types", ->
  x = "b"
  fn = ->
    \.a()
  fn.a = ->
    x
  eq x, fn()  

  @x = "c"
  @a = "no"
  a = "no"
  fn = =>
    \.a()
  fn.a = =>
    @x
  eq @x, fn()
  
test "chaining returns the last value only", ->
  tests = [0, 1,true, [], {}, "a"]
  for test in test
    fn = ->
      test
        \.valueOf()
        \.valueOf() is false
    eq false, fn()
    fn = ->
      test
        \.valueOf() is false
        \.valueOf()
    eq test, fn()
    fn = ->
      test
        \.valueOf()
          \.valueOf() is false
        \.valueOf()
    eq test, fn()
    
test "chaining works several levels deep", ->
  a = new Buffer
  fn = ->
    a
      \.prepend "a"
        \.prepend "a"
          \.prepend "a"
            \.prepend "a"
  eq 4, fn().val.length
  
test "chaining executes lines in order", ->
  a = new Buffer
  fn = ->
    a
      \.prepend "a"
        \.prepend "b"
          \.prepend "c"
          \.prepend "d"
      \.prepend "e"
        \.prepend "f"
  eq a, fn()
  eq "fedcba", a.val
  
test "chaining allows for if and unless", ->
  a = new Buffer
  fn = ->
    a
      \.prepend "a" if true
        \.prepend "b" if false
          \.prepend "c"
          \.prepend "d"
      \.prepend "e" unless false
        \.prepend "f" unless true
  eq a, fn()
  eq "ea", a.val
  
test "chaining can be used inside trailing if and unless statements", ->
  a = new Buffer
  fn = ->
    a
      \.prepend "a" if \.val is ""
        \.prepend "b" if \.val is ""
          \.prepend "c"
          \.prepend "d"
      \.prepend "e" unless \.val is "ea"
        \.prepend "f" unless \.val is "ea"
  eq a, fn()
  eq "ea", a.val
