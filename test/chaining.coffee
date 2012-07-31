test "chaining works with primitives", ->
  tests = [0, 1,true, false, [], {}, "a"]
  for test in test
    fn = ->
      test
        \.valueOf()
    eq test, fn()

test "chaining works across function boundaries", ->
  x = "42"
  fn = ->
    \.a()
  fn.a = ->
    x
  eq x, fn()
  
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
  x = "23"
  fn = ->
    \.a()
      \.b
        \.c()
  fn.a =
    b:
      c: ->
        x
  eq x, fn()
  fn = ->
    true
      \.valueOf()
        \.valueOf() is false
      \.valueOf()
  eq true, fn()
  
test "chaining executes lines in order", ->
  a =
    prepend: (s) ->
      @val = s + (if @val? then @val else "")
      a
    val: ->
      @val
  fn = ->
    a
      \.prepend "a"
        \.prepend "b"
          \.prepend "c"
          \.prepend "d"
      \.prepend "e"
        \.prepend "f"
  eq a, fn()
  eq "fedcba", a.val()



    