Player = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "red"
    height: 32
    width: 32

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.rotation = Point.direction(I, mousePosition)

    I.sprite = Player.animations.swim.wrap((I.age / 6).floor())

  # We must always return self as the last line
  return self

Player.animations =
  swim: Sprite.loadSheet("swim", 256, 157)

