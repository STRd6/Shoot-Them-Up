Earth = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    sprite: "earth"
    scale: 0.5

  # Inherit from game object
  self = GameObject(I)

  self.bind "update", ->
    I.scale *= 1 + playerSpeed / 15000
    I.x -= playerSpeed / 200

  # We must always return self as the last line
  return self
