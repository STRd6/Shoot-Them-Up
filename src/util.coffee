Function::once = ->
  fn = this
  ran = false
  memo = null

  return ->
    if ran
      return memo 
    else
      ran = true
      return memo = fn.apply(this, arguments)

