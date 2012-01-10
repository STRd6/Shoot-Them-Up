window.engine = Engine
  canvas: $("canvas").pixieCanvas()

engine.add
  class: "Player"
  x: 250
  y: 150

window.mousePosition = Point(0, 0)

$(document).mousemove (event) ->
  mousePosition.x = event.pageX
  mousePosition.y = event.pageY

engine.start()

