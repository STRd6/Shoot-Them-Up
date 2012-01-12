canvas = $("canvas").pixieCanvas()

window.engine = Engine
  backgroundColor: false
  canvas: canvas

canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

window.mousePosition = Point(0, 0)

$(document).mousemove (event) ->
  mousePosition.x = event.pageX
  mousePosition.y = event.pageY

DEBUG_DRAW = false
$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Soundblast, .waveHits, Player").each (object) ->
      canvas.drawCircle
        circle: object.circle()
        color: "rgba(255, 0, 255, 0.5)"

engine.setState MainGame(
  level: 1
  background: "clouds"
)

engine.start()
