Craw = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    radius: 48
    sprite: "craw"

  # Inherit from game object
  self = Enemy(I)

  # Add events and methods here
  self.bind "step", ->
    if I.health >= 2
      I.sprite = Craw.sprites.purp
    else
     I.sprite = Craw.sprites.red

  self.bind "hit", ->
    if I.health == 1
      Sound.play "bing"

  self.bind "destroy", ->
    engine.add
      sprite: "bubbles"
      duration: 15
      x: I.x
      y: I.y
      zIndex: 15

  # We must always return self as the last line
  return self

Craw.sprites =
  purp: Sprite.loadByName "craw"
  red: Sprite.loadByName "craw_red"

