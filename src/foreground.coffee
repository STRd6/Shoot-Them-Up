Foreground = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    height: 32
    width: 32
    zIndex: 15

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.x -= playerSpeed * 2

    if I.x < -500
      I.active = false

  # We must always return self as the last line
  return self

