MainGame = (I={}) ->
  Object.reverseMerge I,
    level: "level1"
    music: "ambience"

  # Inherit from game object
  self = GameState(I)

  self.bind "enter", ->
    self.add
      class: "Player"

    10.times (i) ->
      self.add
        class: "Enemy"
        x: 800
        y: 100 + i * 50

    jup = self.add
      sprite: "jupiter"
      x: 800
      y: App.height/2
      zIndex: 5
      scale: 0.1

    jup.bind 'update', ->
      jup.I.scale += playerSpeed / 25000
      jup.I.x -= playerSpeed / 500
      jup.I.y -= playerSpeed / 250

    kilometersToJupiter = 300000
    endDistance = 60000
    window.distanceCovered = 0
    window.playerSpeed = 0
    backgroundOffset = 0
    background = Sprite.loadByName("supernova")

    addGhostShipBoss = (->
      self.add
          class: "GhostShip"
    ).once()

    self.bind 'update', ->
      backgroundOffset -= playerSpeed / 8

      if distanceCovered > 38000
        addGhostShipBoss()

    self.bind "beforeDraw", (canvas) ->
      backgroundOffset += background.width if backgroundOffset < -background.width

      background.draw(canvas, backgroundOffset, 0)
      background.draw(canvas, backgroundOffset + background.width, 0)

    self.bind "overlay", (canvas) ->
      message = "#{(kilometersToJupiter - 5 * distanceCovered).floor()} kilometers to Jupiter"

      canvas.centerText
        x: 256
        y: 50
        text: message
        color: "#000"

      canvas.centerText
        x: 254
        y: 48
        text: message
        color: "#FFF"

    Music.play I.music

  # We must always return self as the last line
  return self

