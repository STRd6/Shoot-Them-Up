Tower = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    sprite: "tower"
    y: App.height
    zIndex: 5
    scale: 0.1

  # Inherit from game object
  self = GameObject(I)

  I.x = 960
  I.y = App.height

  # Add events and methods here
  self.bind "update", ->
    I.scale += playerSpeed / 15000
    I.x -= playerSpeed / 100
    I.y += playerSpeed / 100

  # We must always return self as the last line
  return self

