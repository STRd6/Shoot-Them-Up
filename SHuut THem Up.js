var App;

App = {
  "directories": {
    "animations": "animations",
    "data": "data",
    "entities": "entities",
    "images": "images",
    "lib": "lib",
    "sounds": "sounds",
    "source": "src",
    "test": "test",
    "test_lib": "test_lib",
    "tilemaps": "tilemaps"
  },
  "width": 960,
  "height": 640,
  "library": false,
  "main": "main",
  "wrapMain": true,
  "hotSwap": true,
  "name": "SHuut THem Up",
  "author": "STRd6",
  "libs": {
    "00_gamelib.js": "https://github.com/STRd6/gamelib/raw/pixie/gamelib.js",
    "browserlib.js": "https://github.com/STRd6/browserlib/raw/pixie/browserlib.js",
    "extralib.js": "https://github.com/STRd6/extralib/raw/pixie/extralib.js"
  }
};
;
GhostShip = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    sprite: "ghost_ship"
    width: 32
    radius: 160
    health: 60
    velocity: Point(-2, 0)

  # Inherit from game object
  self = Enemy(I)

  self.unbind "step"

  self.bind "step", ->
    if I.x < 700
      I.velocity.x = 2
    else if I.x > App.width
      I.velocity.x = -4

    I.x += I.velocity.x

  self.bind "hit", ->
    engine.flash()
    Sound.play "boss_hit"

  # We must always return self as the last line
  return self

;
;
;
;

/**
The Animated module, when included in a GameObject, gives the object 
methods to transition from one animation state to another

@name Animated
@module
@constructor

@param {Object} I Instance variables
@param {Object} self Reference to including object
*/

var Animated;

Animated = function(I, self) {
  var advanceFrame, find, initializeState, loadByName, updateSprite, _name, _ref;
  I || (I = {});
  Object.reverseMerge(I, {
    animationName: (_ref = I["class"]) != null ? _ref.underscore() : void 0,
    data: {
      version: "",
      tileset: [
        {
          id: 0,
          src: "",
          title: "",
          circles: [
            {
              x: 0,
              y: 0,
              radius: 0
            }
          ]
        }
      ],
      animations: [
        {
          name: "",
          complete: "",
          interruptible: false,
          speed: "",
          transform: [
            {
              hflip: false,
              vflip: false
            }
          ],
          triggers: {
            "0": ["a trigger"]
          },
          frames: [0],
          transform: [void 0]
        }
      ]
    },
    activeAnimation: {
      name: "",
      complete: "",
      interruptible: false,
      speed: "",
      transform: [
        {
          hflip: false,
          vflip: false
        }
      ],
      triggers: {
        "0": [""]
      },
      frames: [0]
    },
    currentFrameIndex: 0,
    debugAnimation: false,
    hflip: false,
    vflip: false,
    lastUpdate: new Date().getTime(),
    useTimer: false
  });
  loadByName = function(name, callback) {
    var url;
    url = "" + BASE_URL + "/animations/" + name + ".animation?" + (new Date().getTime());
    $.getJSON(url, function(data) {
      I.data = data;
      return typeof callback === "function" ? callback(data) : void 0;
    });
    return I.data;
  };
  initializeState = function() {
    I.activeAnimation = I.data.animations.first();
    return I.spriteLookup = I.data.tileset.map(function(spriteData) {
      return Sprite.fromURL(spriteData.src);
    });
  };
  window[_name = "" + I.animationName + "SpriteLookup"] || (window[_name] = []);
  if (!window["" + I.animationName + "SpriteLookup"].length) {
    window["" + I.animationName + "SpriteLookup"] = I.data.tileset.map(function(spriteData) {
      return Sprite.fromURL(spriteData.src);
    });
  }
  I.spriteLookup = window["" + I.animationName + "SpriteLookup"];
  if (I.data.animations.first().name !== "") {
    initializeState();
  } else if (I.animationName) {
    loadByName(I.animationName, function() {
      return initializeState();
    });
  } else {
    throw "No animation data provided. Use animationName to specify an animation to load from the project or pass in raw JSON to the data key.";
  }
  advanceFrame = function() {
    var frames, nextState, sprite;
    frames = I.activeAnimation.frames;
    if (I.currentFrameIndex === frames.indexOf(frames.last())) {
      self.trigger("Complete");
      if (nextState = I.activeAnimation.complete) {
        I.activeAnimation = find(nextState) || I.activeAnimation;
        I.currentFrameIndex = 0;
      }
    } else {
      I.currentFrameIndex = (I.currentFrameIndex + 1) % frames.length;
    }
    sprite = I.spriteLookup[frames[I.currentFrameIndex]];
    return updateSprite(sprite);
  };
  find = function(name) {
    var nameLower, result;
    result = null;
    nameLower = name.toLowerCase();
    I.data.animations.each(function(animation) {
      if (animation.name.toLowerCase() === nameLower) return result = animation;
    });
    return result;
  };
  updateSprite = function(spriteData) {
    I.sprite = spriteData;
    I.width = spriteData.width;
    return I.height = spriteData.height;
  };
  return {
    /**
    Transitions to a new active animation. Will not transition if the new state
    has the same name as the current one or if the active animation is marked as locked.

    @param {String} newState The name of the target state you wish to transition to.
    */
    transition: function(newState, force) {
      var toNextState;
      if (newState === I.activeAnimation.name) return;
      toNextState = function(state) {
        var firstFrame, firstSprite, nextState;
        if (nextState = find(state)) {
          I.activeAnimation = nextState;
          firstFrame = I.activeAnimation.frames.first();
          firstSprite = I.spriteLookup[firstFrame];
          I.currentFrameIndex = 0;
          return updateSprite(firstSprite);
        } else {
          if (I.debugAnimation) {
            return warn("Could not find animation state '" + newState + "'. The current transition will be ignored");
          }
        }
      };
      if (force) {
        return toNextState(newState);
      } else {
        if (!I.activeAnimation.interruptible) {
          if (I.debugAnimation) {
            warn("Cannot transition to '" + newState + "' because '" + I.activeAnimation.name + "' is locked");
          }
          return;
        }
        return toNextState(newState);
      }
    },
    before: {
      update: function() {
        var time, triggers, updateFrame, _ref2, _ref3;
        if (I.useTimer) {
          time = new Date().getTime();
          if (updateFrame = (time - I.lastUpdate) >= I.activeAnimation.speed) {
            I.lastUpdate = time;
            if (triggers = (_ref2 = I.activeAnimation.triggers) != null ? _ref2[I.currentFrameIndex] : void 0) {
              triggers.each(function(event) {
                return self.trigger(event);
              });
            }
            return advanceFrame();
          }
        } else {
          if (triggers = (_ref3 = I.activeAnimation.triggers) != null ? _ref3[I.currentFrameIndex] : void 0) {
            triggers.each(function(event) {
              return self.trigger(event);
            });
          }
          return advanceFrame();
        }
      }
    }
  };
};
;

(function() {
  var Animation, fromPixieId;
  Animation = function(data) {
    var activeAnimation, advanceFrame, currentSprite, spriteLookup;
    spriteLookup = {};
    activeAnimation = data.animations[0];
    currentSprite = data.animations[0].frames[0];
    advanceFrame = function(animation) {
      var frames;
      frames = animation.frames;
      return currentSprite = frames[(frames.indexOf(currentSprite) + 1) % frames.length];
    };
    data.tileset.each(function(spriteData, i) {
      return spriteLookup[i] = Sprite.fromURL(spriteData.src);
    });
    return $.extend(data, {
      currentSprite: function() {
        return currentSprite;
      },
      draw: function(canvas, x, y) {
        return canvas.withTransform(Matrix.translation(x, y), function() {
          return spriteLookup[currentSprite].draw(canvas, 0, 0);
        });
      },
      frames: function() {
        return activeAnimation.frames;
      },
      update: function() {
        return advanceFrame(activeAnimation);
      },
      active: function(name) {
        if (name !== void 0) {
          if (data.animations[name]) {
            return currentSprite = data.animations[name].frames[0];
          }
        } else {
          return activeAnimation;
        }
      }
    });
  };
  window.Animation = function(name, callback) {
    return fromPixieId(App.Animations[name], callback);
  };
  fromPixieId = function(id, callback) {
    var proxy, url;
    url = "http://pixie.strd6.com/s3/animations/" + id + "/data.json";
    proxy = {
      active: $.noop,
      draw: $.noop
    };
    $.getJSON(url, function(data) {
      $.extend(proxy, Animation(data));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  return window.Animation.fromPixieId = fromPixieId;
})();
;

/**
The <code>FPSCounter</code> module tracks and displays the framerate.

<code><pre>
window.engine = Engine
  ...
  includedModules: ["FPSCounter"]
  FPSColor: "#080"
</pre></code>

@name FPSCounter
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/

Engine.FPSCounter = function(I, self) {
  var framerate;
  Object.reverseMerge(I, {
    showFPS: true,
    FPSColor: "#FFF"
  });
  framerate = Framerate({
    noDOM: true
  });
  return self.bind("overlay", function(canvas) {
    if (I.showFPS) {
      canvas.font("bold 9pt consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
      canvas.drawText({
        color: I.FPSColor,
        position: Point(6, 18),
        text: "fps: " + framerate.fps
      });
    }
    return framerate.rendered();
  });
};
;

(function($) {
  /**
  The <code>Joysticks</code> module gives the engine access to joysticks.

  <code><pre>
  # First you need to add the joysticks module to the engine
  window.engine = Engine
    ...
    includedModules: ["Joysticks"]
  # Then you need to get a controller reference
  # id = 0 for player 1, etc.
  controller = engine.controller(id)

  # Point indicating direction primary axis is held
  direction = controller.position()

  # Check if buttons are held
  controller.actionDown("A")
  controller.actionDown("B")
  controller.actionDown("X")
  controller.actionDown("Y")
  </pre></code>

  @name Joysticks
  @fieldOf Engine
  @module

  @param {Object} I Instance variables
  @param {Object} self Reference to the engine
  */  return Engine.Joysticks = function(I, self) {
    Joysticks.init();
    self.bind("update", function() {
      Joysticks.init();
      return Joysticks.update();
    });
    return {
      /**
      Get a controller for a given joystick id.

      @name controller
      @methodOf Engine.Joysticks#

      @param {Number} i The joystick id to get the controller of.
      */
      controller: function(i) {
        return Joysticks.getController(i);
      }
    };
  };
})();
;

/**
The <code>Tilemap</code> module provides a way to load tilemaps in the engine.

@name Tilemap
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/

Engine.Tilemap = function(I, self) {
  var clearObjects, map, updating;
  map = null;
  updating = false;
  clearObjects = false;
  self.bind("beforeDraw", function(canvas) {
    return map != null ? map.draw(canvas) : void 0;
  });
  self.bind("update", function() {
    return updating = true;
  });
  self.bind("afterUpdate", function() {
    updating = false;
    if (clearObjects) {
      self.objects().clear();
      return clearObjects = false;
    }
  });
  return {
    /**
    Loads a new may and unloads any existing map or entities.

    @name loadMap
    @methodOf Engine#
    */
    loadMap: function(name, complete) {
      clearObjects = updating;
      return map = Tilemap.load({
        name: name,
        complete: complete,
        entity: self.add
      });
    }
  };
};
;

/**
This object keeps track of framerate and displays it by creating and appending an
html element to the DOM.

Once created you call snapshot at the end of every rendering cycle.

@name Framerate
@constructor
*/

var Framerate;

Framerate = function(options) {
  var element, framerateUpdateInterval, framerates, numFramerates, renderTime, self, updateFramerate;
  options || (options = {});
  if (!options.noDOM) {
    element = $("<div>", {
      css: {
        color: "#FFF",
        fontFamily: "consolas, 'Courier New', 'andale mono', 'lucida console', monospace",
        fontWeight: "bold",
        paddingLeft: 4,
        position: "fixed",
        top: 0,
        left: 0
      }
    }).appendTo('body').get(0);
  }
  numFramerates = 15;
  framerateUpdateInterval = 250;
  renderTime = -1;
  framerates = [];
  updateFramerate = function() {
    var framerate, rate, tot, _i, _len;
    tot = 0;
    for (_i = 0, _len = framerates.length; _i < _len; _i++) {
      rate = framerates[_i];
      tot += rate;
    }
    framerate = (tot / framerates.length).round();
    self.fps = framerate;
    if (element) return element.innerHTML = "fps: " + framerate;
  };
  setInterval(updateFramerate, framerateUpdateInterval);
  /**
  Call this method everytime you render.

  @name rendered
  @methodOf Framerate#
  */
  return self = {
    rendered: function() {
      var framerate, newTime, t;
      if (renderTime < 0) {
        return renderTime = new Date().getTime();
      } else {
        newTime = new Date().getTime();
        t = newTime - renderTime;
        framerate = 1000 / t;
        framerates.push(framerate);
        while (framerates.length > numFramerates) {
          framerates.shift();
        }
        return renderTime = newTime;
      }
    }
  };
};
;

(function() {
  var Map, Tilemap, fromPixieId, loadByName;
  Map = function(data, entityCallback) {
    var entity, loadEntities, spriteLookup, tileHeight, tileWidth, uuid, _ref;
    tileHeight = data.tileHeight;
    tileWidth = data.tileWidth;
    spriteLookup = {};
    _ref = App.entities;
    for (uuid in _ref) {
      entity = _ref[uuid];
      spriteLookup[uuid] = Sprite.fromURL(entity.tileSrc);
    }
    loadEntities = function() {
      if (!entityCallback) return;
      return data.layers.each(function(layer, layerIndex) {
        var entities, entity, entityData, x, y, _i, _len, _results;
        if (layer.name.match(/entities/i)) {
          if (entities = layer.entities) {
            _results = [];
            for (_i = 0, _len = entities.length; _i < _len; _i++) {
              entity = entities[_i];
              x = entity.x, y = entity.y, uuid = entity.uuid;
              entityData = Object.extend({
                layer: layerIndex,
                sprite: spriteLookup[uuid],
                x: x + tileWidth / 2,
                y: y + tileHeight / 2
              }, App.entities[uuid], entity.properties);
              _results.push(entityCallback(entityData));
            }
            return _results;
          }
        }
      });
    };
    loadEntities();
    return Object.extend(data, {
      draw: function(canvas, x, y) {
        return canvas.withTransform(Matrix.translation(x, y), function() {
          return data.layers.each(function(layer) {
            if (layer.name.match(/entities/i)) return;
            return layer.tiles.each(function(row, y) {
              return row.each(function(uuid, x) {
                var sprite;
                if (sprite = spriteLookup[uuid]) {
                  return sprite.draw(canvas, x * tileWidth, y * tileHeight);
                }
              });
            });
          });
        });
      }
    });
  };
  Tilemap = function(name, callback, entityCallback) {
    return fromPixieId(App.Tilemaps[name], callback, entityCallback);
  };
  fromPixieId = function(id, callback, entityCallback) {
    var proxy, url;
    url = "http://pixieengine.com/s3/tilemaps/" + id + "/data.json";
    proxy = {
      draw: function() {}
    };
    $.getJSON(url, function(data) {
      Object.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  loadByName = function(name, callback, entityCallback) {
    var directory, proxy, url, _ref;
    directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.tilemaps : void 0 : void 0) || "data";
    url = "" + BASE_URL + "/" + directory + "/" + name + ".tilemap?" + (new Date().getTime());
    proxy = {
      draw: function() {}
    };
    $.getJSON(url, function(data) {
      Object.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  Tilemap.fromPixieId = fromPixieId;
  Tilemap.load = function(options) {
    if (options.pixieId) {
      return fromPixieId(options.pixieId, options.complete, options.entity);
    } else if (options.name) {
      return loadByName(options.name, options.complete, options.entity);
    }
  };
  return (typeof exports !== "undefined" && exports !== null ? exports : this)["Tilemap"] = Tilemap;
})();
;
;
;
var Enemy;

Enemy = function(I) {
  var self;
  if (I == null) I = {};
  Object.reverseMerge(I, {
    color: "blue",
    health: 2,
    height: 32,
    radius: 48,
    sprite: "craw",
    width: 32,
    zIndex: 10,
    waveHits: true
  });
  self = GameObject(I);
  self.bind("step", function() {
    I.x -= playerSpeed;
    if (I.health >= 2) {
      return I.sprite = Enemy.sprites.craw;
    } else {
      return I.sprite = Enemy.sprites.crawRed;
    }
  });
  self.bind("hit", function() {
    I.health -= 1;
    if (I.health <= 0) return self.destroy();
  });
  self.bind("destroy", function() {
    return engine.add({
      sprite: "bubbles",
      duration: 15,
      x: I.x,
      y: I.y,
      zIndex: 15
    });
  });
  return self;
};

Enemy.sprites = {
  craw: Sprite.loadByName("craw"),
  crawRed: Sprite.loadByName("craw_red")
};
;
var GhostShip;

GhostShip = function(I) {
  var self;
  if (I == null) I = {};
  Object.reverseMerge(I, {
    color: "blue",
    height: 32,
    sprite: "ghost_ship",
    width: 32,
    radius: 160,
    health: 60,
    velocity: Point(-2, 0)
  });
  self = Enemy(I);
  self.unbind("step");
  self.bind("step", function() {
    if (I.x < 700) {
      I.velocity.x = 2;
    } else if (I.x > App.width) {
      I.velocity.x = -4;
    }
    return I.x += I.velocity.x;
  });
  self.bind("hit", function() {
    return engine.flash();
  });
  return self;
};
;
var Player;

Player = function(I) {
  var self;
  if (I == null) I = {};
  Object.reverseMerge(I, {
    color: "red",
    height: 32,
    radius: 16,
    width: 32,
    zIndex: 8
  });
  self = GameObject(I);
  self.bind("update", function() {
    var amplitude;
    I.rotation = Point.direction(I, mousePosition);
    amplitude = Point.distance(I, mousePosition) / 10;
    I.sprite = Player.animations.swim.wrap((I.age / 6).floor());
    I.y += Math.sin(I.rotation) * amplitude;
    window.playerSpeed = Math.cos(I.rotation) * amplitude / 6;
    window.distanceCovered += window.playerSpeed;
    if (I.age % 30 === 0) {
      return engine.add({
        "class": "Soundblast",
        x: I.x,
        y: I.y,
        rotation: I.rotation
      });
    }
  });
  return self;
};

Player.animations = {
  swim: Sprite.loadSheet("swim", 256, 157)
};
;
var Soundblast;

Soundblast = function(I) {
  var self;
  if (I == null) I = {};
  Object.reverseMerge(I, {
    color: "blue",
    sprite: "soundblast",
    speed: 10,
    radius: 64,
    zIndex: 9
  });
  self = GameObject(I);
  self.bind("update", function() {
    I.sprite = Soundblast.animation.wrap((I.age / 6).floor());
    I.x += Math.cos(I.rotation) * I.speed;
    I.y += Math.sin(I.rotation) * I.speed;
    engine.find(".waveHits").each(function(enemy) {
      if (Collision.circular(enemy.circle(), self.circle())) {
        self.destroy();
        return enemy.trigger("hit", self);
      }
    });
    if (I.x < 0 || I.x > App.width || I.y < 0 || I.y > App.height) {
      return self.destroy();
    }
  });
  return self;
};

Soundblast.animation = Sprite.loadSheet("soundblast", 128, 95);
;

Function.prototype.once = function() {
  var fn, memo, ran;
  fn = this;
  ran = false;
  memo = null;
  return function() {
    if (ran) {
      return memo;
    } else {
      ran = true;
      return memo = fn.apply(this, arguments);
    }
  };
};
;

App.entities = {};
;
;$(function(){ var DEBUG_DRAW, addGhostShipBoss, background, backgroundOffset, canvas, endDistance, jup, kilometersToJupiter;

canvas = $("canvas").pixieCanvas();

window.engine = Engine({
  backgroundColor: false,
  canvas: canvas
});

engine.add({
  "class": "Player",
  x: 250,
  y: 150
});

10..times(function(i) {
  return engine.add({
    "class": "Enemy",
    x: 800,
    y: 100 + i * 50
  });
});

jup = engine.add({
  sprite: "jupiter",
  x: 800,
  y: App.height / 2,
  zIndex: 5,
  scale: 0.1
});

jup.bind('update', function() {
  jup.I.scale += playerSpeed / 25000;
  jup.I.x -= playerSpeed / 500;
  return jup.I.y -= playerSpeed / 250;
});

kilometersToJupiter = 300000;

endDistance = 60000;

window.distanceCovered = 0;

window.playerSpeed = 0;

backgroundOffset = 0;

background = Sprite.loadByName("supernova");

addGhostShipBoss = (function() {
  return engine.add({
    "class": "GhostShip",
    x: App.width + 320,
    y: App.height / 2
  });
}).once();

engine.bind('update', function() {
  backgroundOffset -= playerSpeed / 8;
  if (distanceCovered > 38000) return addGhostShipBoss();
});

engine.bind("beforeDraw", function(canvas) {
  if (backgroundOffset < -background.width) backgroundOffset += background.width;
  background.draw(canvas, backgroundOffset, 0);
  return background.draw(canvas, backgroundOffset + background.width, 0);
});

canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace");

engine.bind("overlay", function(canvas) {
  var message;
  message = "" + ((kilometersToJupiter - 5 * distanceCovered).floor()) + " kilometers to Jupiter";
  canvas.centerText({
    x: 256,
    y: 50,
    text: message,
    color: "#000"
  });
  return canvas.centerText({
    x: 254,
    y: 48,
    text: message,
    color: "#FFF"
  });
});

window.mousePosition = Point(0, 0);

$(document).mousemove(function(event) {
  mousePosition.x = event.pageX;
  return mousePosition.y = event.pageY;
});

engine.start();

Music.play("ambience");

DEBUG_DRAW = false;

$(document).bind("keydown", "0", function() {
  return DEBUG_DRAW = !DEBUG_DRAW;
});

engine.bind("draw", function(canvas) {
  if (DEBUG_DRAW) {
    return engine.find("Soundblast, Enemy, Player").each(function(object) {
      return canvas.drawCircle({
        circle: object.circle(),
        color: "rgba(255, 0, 255, 0.5)"
      });
    });
  }
});
 });