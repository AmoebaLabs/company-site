
class AmoebaSite.Presentation.Slide_PreparingYou extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("preparingYouSlide")
    @transition = 'zoom'

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      @cube.tearDown()
      @cube = undefined

  _start: () =>
    @cube = new AmoebaSite.Cube(@el, this._stepOneCallback)
    @cube.rotateToIndex(2)

  _stepOneCallback: () =>
    console.log 'hello'

class AmoebaSite.Cube
  constructor: (@parentDiv, @callback) ->
    this._initializeVariables()
    this._setupCube()
    this._transformToCube()

    @rotationSteps = [
      x:0
      y:0
      z:0
    ,
      x:0
      y:-90
      z:0
    ,
      x:0
      y:-90
      z:90
    ,
      x:0
      y:-180
      z:90
    ,
      x:-90
      y:-180
      z:90
    ,
      x:-90
      y:-180
      z:180
    ]

  tearDown: () =>
    console.log 'todo'

  rotateToIndex: (theIndex) =>
    r = @rotationSteps[theIndex]

    $("#threeDCube").transition(
      rotateX: r.x
      rotateY: r.y
      rotate: r.z
      duration: 400
    )

  _setupCube: =>
    stage = $('<div/>')
      .appendTo(@parentDiv)
      .attr("id", "threeDCubeStage")
      .css(AmoebaSB.layout.center(@cubeSize, @cubeSize))

    cube = $('<div/>')
      .appendTo(stage)
      .attr("id", "threeDCube")

    _.each([0..5], (text, index) =>
      @cubeFaces.push(
        $('<div/>')
          .appendTo(cube)
          .text(text)
          .css(@flatTransforms[index])
      )
    )

  _cubeTransform: (x, y, z, pop=0, spin=0) =>
    x += spin
    y += spin
    z += spin

    result =
      transform: "rotateY(#{y}deg) rotateX(#{x}deg) rotateZ(#{z}deg) translateZ(#{(@cubeSize / 2) + pop}px)"

    return result

  _flatTransform: (theIndex) =>
    result =
      transform: "translateY(#{theIndex*-34}px) translateX(#{theIndex*63}px)"

    return result

  _transformToCube: () =>
    theDelay = 200
    _.each(@cubeFaces, (face, index) =>
      face.transition({delay: 800})
      face.transition(_.extend({delay: index*theDelay}, @cubeTransforms[index]))
    )

  _initializeVariables: () =>
    @cubeSize = 420
    @cubeFaces = []

    @cubeTransforms = [
      this._cubeTransform(0, 0, 0)
      this._cubeTransform(0, 90, 0)
      this._cubeTransform(90, 90, 0)
      this._cubeTransform(0, 180, 90)
      this._cubeTransform(0, -90, 90)
      this._cubeTransform(-90, 0, 0)
    ]

    pop = 330
    spin = 24
    @popCubeTransforms = [
      this._cubeTransform(0, 0, 0, pop, spin)
      this._cubeTransform(0, 90, 0, pop, spin)
      this._cubeTransform(90, 90, 0, pop, spin)
      this._cubeTransform(0, 180, 90, pop, spin)
      this._cubeTransform(0, -90, 90, pop, spin)
      this._cubeTransform(-90, 0, 0, pop, spin)
    ]

    @flatTransforms = []
    _.each([0..5], (element, index) =>
      @flatTransforms.push(this._flatTransform(index+1))
    )


