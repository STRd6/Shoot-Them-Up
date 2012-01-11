GhostShip = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    sprite: "ghost_ship"
    width: 32
    radius: 160
    health: 15

  # Inherit from game object
  self = Enemy(I)

  self.unbind "step"

  # We must always return self as the last line
  return self

