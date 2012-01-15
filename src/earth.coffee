Earth = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    sprite: "earth"

  # Inherit from game object
  self = GameObject(I)

  self.bind "update", ->


  # We must always return self as the last line
  return self
