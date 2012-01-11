Enemy = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    health: 2
    height: 32
    radius: 48
    sprite: "craw"
    width: 32
    zIndex: 10
    waveHits: true

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "step", ->
    I.x -= playerSpeed

    if I.health >= 2
      I.sprite = Enemy.sprites.craw
    else
     I.sprite = Enemy.sprites.crawRed

  self.bind "hit", ->
    I.health -= 1

    if I.health <= 0
      self.destroy()

  self.bind "destroy", ->
    engine.add
      sprite: "bubbles"
      duration: 15
      x: I.x
      y: I.y
      zIndex: 15

  # We must always return self as the last line
  return self

Enemy.sprites =
  craw: Sprite.loadByName "craw"
  crawRed: Sprite.loadByName "craw_red"

