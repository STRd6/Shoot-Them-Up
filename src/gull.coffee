Gull = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    radius: 64

  # Inherit from game object
  self = Enemy(I)

  # Add events and methods here
  self.bind "update", ->
    I.sprite = Gull.animation.wrap((I.age / 6).floor())
    I.x -= 4

    I.y += Math.cos(I.age * Math.TAU / 60) * 20

    I.hflip = true

  # We must always return self as the last line
  return self

Gull.animation = Sprite.loadSheet("gull", 256, 234)

