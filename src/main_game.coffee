MainGame = (I={}) ->
  Object.reverseMerge I,
    level: "level1"

  # Inherit from game object
  self = GameState(I)

  self.bind "enter", ->

  self.bind 'overlay', (canvas) ->
    if player = engine.find("Player").first()
      player.drawHealthMeters(canvas)

  # We must always return self as the last line
  return self

