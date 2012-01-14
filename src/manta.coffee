Manta = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    radius: 128
    health: 5

  # Inherit from game object
  self = Enemy(I)

  # Add events and methods here
  self.bind "update", ->
    I.sprite = Manta.animation.wrap((I.age / 6).floor() % 2)
    I.x -= 4

    I.y += Math.cos(I.age * Math.TAU / 60) * 10

    I.hflip = true

  # We must always return self as the last line
  return self

Manta.animation = Sprite.loadSheet("manta", 584, 456)

