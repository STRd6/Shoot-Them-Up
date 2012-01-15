Geod = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    height: 32
    sprite: "geod"
    width: 32
    radius: 160
    health: 13
    rotation: 0

  self = Enemy(I)

  I.x = App.width + 320
  I.y = App.height / 2

  self.unbind "step"

  self.bind "step", ->
    targetX = Math.cos(Math.TAU/720 * I.age) * 128 + App.width * 3 / 4
    I.x = I.x.approach(targetX, 1)

    targetY = Math.sin(Math.TAU/450 * I.age) * 96 + App.height / 2
    I.y = I.y.approach(targetY, 5)

    I.rotation += (1/960).rotations

    I.scale = 0.9 + Math.sin(Math.TAU/450 * I.age) * 0.1

  self.unbind "destroy"

  self.bind "destroy", ->
    engine.add
      class: "Earth"
      x: I.x
      y: I.y

  self.bind "hit", ->
    engine.flash()
    Sound.play "boss_hit"

  return self

