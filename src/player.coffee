Player = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "red"
    height: 32
    width: 32
    zIndex: 8

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.rotation = Point.direction(I, mousePosition)
    amplitude = Point.distance(I, mousePosition) / 10

    I.sprite = Player.animations.swim.wrap((I.age / 6).floor())

    I.y += Math.sin(I.rotation) * amplitude

    window.playerSpeed = Math.cos(I.rotation) * amplitude / 6

    if I.age % 30 == 0
      engine.add
        class: "Soundblast"
        x: I.x
        y: I.y
        rotation: I.rotation

  # We must always return self as the last line
  return self

Player.animations =
  swim: Sprite.loadSheet("swim", 256, 157)

