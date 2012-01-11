GhostShip = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    sprite: "ghost_ship"
    width: 32
    radius: 160
    health: 15
    velocity: Point(-2, 0)

  # Inherit from game object
  self = Enemy(I)

  self.unbind "step"

  self.bind "step", ->
    if I.x < 700
      I.velocity.x = 2
    else if I.x > App.width
      I.velocity.x = -4

    I.x += I.velocity.x

  # We must always return self as the last line
  return self

