MainGame = (I={}) ->
  Object.reverseMerge I,
    level: "level1"
    music: "ambience"
    spawnEvents: []

  # Inherit from game object
  self = GameState(I)

  SPAWN_BUFFER = 400 + App.width

  self.bind "enter", ->
    self.add
      class: "Player"

    27.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 900 + 1000 * i
        y: App.height / 2

      I.spawnEvents.push
        class: "Enemy"
        x: 1400 + 1000 * i
        y: App.height / 4

      I.spawnEvents.push
        class: "Enemy"
        x: 2100 + 1300 * i
        y: 3 * App.height / 4

    8.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 1000 + 500 * i
        y: 100 + i * 50

    10.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 5000 + 250 * i
        y: 50 + App.height/2 * i / 13

      I.spawnEvents.push
        class: "Enemy"
        x: 5000 + 250 * i
        y: App.height - 50 - App.height/2 * i / 13

    50.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 7500 + 100 * i
        y: App.height / 2 + Math.sin(i * Math.TAU / 20) * App.height / 2

    20.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 12500 + 100 * i
        y: App.height / 2 + Math.sin(i * Math.TAU / 10) * App.height / 2

    20.times (i) ->
      I.spawnEvents.push
        class: "Enemy"
        x: 14500 + 50 * i
        y: App.height / 2 + Math.sin(i * Math.TAU / 10) * App.height / 2

    I.spawnEvents.push
      class: "GhostShip"
      x: 38000
      y: App.height / 2

    I.spawnEvents.sort (a, b) ->
      a.x - b.x

    self.add
      class: "Jupiter"

    kilometersToJupiter = 300000
    endDistance = 60000
    window.distanceCovered = 0
    window.playerSpeed = 0

    spawnLine = 0
    eventIndex = 0

    backgroundOffset = 0
    background = Sprite.loadByName("supernova")

    processSpawnEvent = (event) ->
      engine.add
        class: event.class
        x: event.x - (spawnLine - SPAWN_BUFFER) # x is adjusted based on current spawn line
        y: event.y

    triggerEnd = (->
      self.cameras().first().fadeOut()

      engine.delay 30, ->
        # TODO: Load Level 2
        engine.setState MainGame()
    ).once()

    self.bind 'update', ->
      #TODO Background layers
      backgroundOffset -= playerSpeed / 8

      if (newSpawnLine = distanceCovered + SPAWN_BUFFER) > spawnLine
        spawnLine = newSpawnLine

      # Spawn distance related objects and events
      while (nextEvent = I.spawnEvents[eventIndex]) and nextEvent.x < spawnLine
        processSpawnEvent(nextEvent)
        eventIndex += 1

      if distanceCovered >= endDistance
        triggerEnd()

    self.bind "beforeDraw", (canvas) ->
      backgroundOffset += background.width if backgroundOffset < -background.width

      background.draw(canvas, backgroundOffset, 0)
      background.draw(canvas, backgroundOffset + background.width, 0)

    self.bind "overlay", (canvas) ->
      message = "#{Math.max((kilometersToJupiter - 5 * distanceCovered).floor(), 0)} kilometers to Jupiter"

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

