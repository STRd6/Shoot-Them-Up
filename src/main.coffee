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

speed = 2
backgroundOffset = 0
background = Sprite.loadByName("supernova")

engine.bind 'update', ->
  backgroundOffset -= speed

engine.bind "beforeDraw", (canvas) ->
  backgroundOffset += background.width if backgroundOffset < -background.width

  background.draw(canvas, backgroundOffset, 0)
  background.draw(canvas, backgroundOffset + background.width, 0)

window.mousePosition = Point(0, 0)

$(document).mousemove (event) ->
  mousePosition.x = event.pageX
  mousePosition.y = event.pageY

engine.start()

