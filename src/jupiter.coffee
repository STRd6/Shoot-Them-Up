Jupiter = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    sprite: "jupiter"
    x: 800
    y: App.height/2
    zIndex: 5
    scale: 0.1

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.scale += playerSpeed / 25000
    I.x -= playerSpeed / 500
    I.y -= playerSpeed / 250

  # We must always return self as the last line
  return self

