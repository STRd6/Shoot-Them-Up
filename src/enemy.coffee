Enemy = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    sprite: "craw"
    width: 32
    zIndex: 10

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.x -= playerSpeed

  # We must always return self as the last line
  return self

