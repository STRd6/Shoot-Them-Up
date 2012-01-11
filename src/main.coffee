window.engine = Engine
  backgroundColor: false
  canvas: $("canvas").pixieCanvas()

engine.add
  class: "Player"
  x: 250
  y: 150

10.times (i) ->
  engine.add
    class: "Enemy"
    x: 800
    y: 100 + i * 50

jup = engine.add
  sprite: "jupiter"
  x: 800
  y: App.height/2
  zIndex: 5
  scale: 0.1

jup.bind 'update', ->
  jup.I.scale += playerSpeed / 25000
  jup.I.x -= playerSpeed / 500
  jup.I.y -= playerSpeed / 250

window.distanceCovered = 0
window.playerSpeed = 0
backgroundOffset = 0
background = Sprite.loadByName("supernova")

addGhostShipBoss = (->
  engine.add
      class: "GhostShip"
      x: App.width + 320
      y: App.height / 2
).once()

engine.bind 'update', ->
  backgroundOffset -= playerSpeed / 8

  if distanceCovered > 18000
    addGhostShipBoss()

engine.bind "beforeDraw", (canvas) ->
  backgroundOffset += background.width if backgroundOffset < -background.width

  background.draw(canvas, backgroundOffset, 0)
  background.draw(canvas, backgroundOffset + background.width, 0)

window.mousePosition = Point(0, 0)

$(document).mousemove (event) ->
  mousePosition.x = event.pageX
  mousePosition.y = event.pageY

engine.start()

Music.play "ambience"

DEBUG_DRAW = false
$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Soundblast, Enemy, Player").each (object) ->
      canvas.drawCircle
        circle: object.circle()
        color: "rgba(255, 0, 255, 0.5)"
