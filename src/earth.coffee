Earth = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    scale: 0.25

  # Inherit from game object
  self = GameObject(I)

  self.bind "update", ->
    I.sprite = Earth.sprite
    I.scale *= 1 + playerSpeed / 7000
    I.x -= playerSpeed / 200

  # We must always return self as the last line
  return self

# "pre"-load
Earth.sprite = Sprite.loadByName "earth"

