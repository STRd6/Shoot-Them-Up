Player = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "red"
    height: 32
    radius: 16
    width: 32
    x: 250
    y: App.height / 2
    zIndex: 8
    cooldown: 0

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    I.rotation = Point.direction(I, mousePosition)
    amplitude = Point.distance(I, mousePosition) / 10

    I.sprite = Player.animations.swim.wrap((I.age / 6).floor())

    I.y += Math.sin(I.rotation) * amplitude

    window.playerSpeed = Math.cos(I.rotation) * amplitude / 6
    window.distanceCovered += window.playerSpeed

    I.cooldown = I.cooldown.approach(0, 1)

    if mousePressed
      unless I.cooldown
        engine.add
          class: "Soundblast"
          x: I.x
          y: I.y
          rotation: I.rotation

        I.cooldown = 15

    # Reset mouse
    window.mousePressed = false

  # We must always return self as the last line
  return self

Player.animations =
  swim: Sprite.loadSheet("swim", 256, 157)

