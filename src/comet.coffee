Comet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
    rotation: 6 * Math.TAU / 16
    scale: rand() / 5 + 0.1

  speed = I.scale * I.scale * 150

  I.velocity = Point.fromAngle(I.rotation).scale(speed)

  I.x = rand(2 * App.width / 3) + App.width / 3
  I.y = -50

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.x += I.velocity.x - playerSpeed / 8
    I.y += I.velocity.y

    if I.y > App.height + 256
      I.active = false

    I.sprite = Comet.sprites.wrap((I.age / 6).floor())

  # We must always return self as the last line
  return self

Comet.sprites = Sprite.loadSheet("comet", 408, 144)

