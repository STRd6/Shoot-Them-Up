Soundblast = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    sprite: "soundblast"
    speed: 10
    radius: 64

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.sprite = Soundblast.animation.wrap((I.age / 6).floor())

    I.x += Math.cos(I.rotation) * I.speed
    I.y += Math.sin(I.rotation) * I.speed

    engine.find("Enemy").each (enemy) ->
      if Collision.circular enemy, self
        self.destroy()
        enemy.trigger "hit", self

    if I.x < 0 || I.x > App.width || I.y < 0 || I.y > App.height
      self.destroy()

  # We must always return self as the last line
  return self

Soundblast.animation = Sprite.loadSheet("soundblast", 128, 95)

