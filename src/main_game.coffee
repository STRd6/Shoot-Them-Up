MainGame = (I={}) ->
  Object.reverseMerge I,
    level: 1
    music: "ambience"

  # Inherit from game object
  self = GameState(I)

  SPAWN_BUFFER = 400 + App.width

  self.bind "enter", ->
    self.add
      class: "Player"

    level = MainGame.levelData[I.level]
    I.spawnEvents = level.eventData

    I.spawnEvents.sort (a, b) ->
      a.x - b.x

    endDistance = level.objectiveDistance / (level.distanceScale || 1)
    window.distanceCovered = 0
    window.playerSpeed = 0

    spawnLine = 0
    eventIndex = 0

    backgroundOffset = 0
    background = Sprite.loadByName(level.background)

    processSpawnEvent = (event) ->
      engine.add
        class: event.class
        x: event.x - (spawnLine - SPAWN_BUFFER) # x is adjusted based on current spawn line
        y: event.y

    triggerEnd = (->
      self.cameras().first().fadeOut()

      engine.delay 30, ->
        engine.setState MainGame(
          level: I.level + 1
        )
    ).once()

    self.bind 'update', ->
      #TODO Background layers
      backgroundOffset -= playerSpeed * level.parallax

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
      message = "#{Math.max((level.objectiveDistance - (level.distanceScale || 1) * distanceCovered).floor(), 0)} #{level.units || "kilometers"} to #{level.objective}"

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

MainGame.levelData =
  1:
    background: "supernova"
    parallax: 1/8
    objective: "Jupiter"
    objectiveDistance: 300000
    distanceScale: 5
  2:
    background: "clouds"
    parallax: 1/2
    objective: "The Tower"
    objectiveDistance: 60000
    units: "meters"
  3:
    background: "tower_bg"
    parallax: 1
    objective: "The Bottom"
    objectiveDistance: 10000
    units: "meters"

(->
  level1 = MainGame.levelData[1].eventData = []

  27.times (i) ->
    level1.push
      class: "Enemy"
      x: 900 + 1000 * i
      y: App.height / 2

    level1.push
      class: "Enemy"
      x: 1400 + 1000 * i
      y: App.height / 4

    level1.push
      class: "Enemy"
      x: 2100 + 1300 * i
      y: 3 * App.height / 4

  8.times (i) ->
    level1.push
      class: "Enemy"
      x: 1000 + 500 * i
      y: 100 + i * 50

  10.times (i) ->
    level1.push
      class: "Enemy"
      x: 5000 + 250 * i
      y: 50 + App.height/2 * i / 13

    level1.push
      class: "Enemy"
      x: 5000 + 250 * i
      y: App.height - 50 - App.height/2 * i / 13

  50.times (i) ->
    level1.push
      class: "Enemy"
      x: 7500 + 100 * i
      y: App.height / 2 + Math.sin(i * Math.TAU / 20) * App.height / 2

  20.times (i) ->
    level1.push
      class: "Enemy"
      x: 12500 + 100 * i
      y: App.height / 2 + Math.sin(i * Math.TAU / 10) * App.height / 2

  20.times (i) ->
    level1.push
      class: "Enemy"
      x: 14500 + 50 * i
      y: App.height / 2 + Math.sin(i * Math.TAU / 10) * App.height / 2

  level1.push
    class: "Jupiter"
    x: 800
    y: App.height/2

  level1.push
    class: "GhostShip"
    x: 38000
    y: App.height / 2

  # Level 2
  level2 = MainGame.levelData[2].eventData = []

  level2.push
    class: "Tower"
    y: App.height
    x: 24000

  26.times (i) ->
    level2.push
      class: "Manta"
      x: i * 1700 + 16000
      y: rand(App.height / 2) + App.height/2

  10.times (i) ->
    20.times (j) ->
      level2.push
        class: "Gull"
        x: i * 5000 + j * 100 + 2000
        y: rand(App.height)

  level3 = MainGame.levelData[3].eventData = []
)()

