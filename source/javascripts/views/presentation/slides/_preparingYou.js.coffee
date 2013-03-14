
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

  _stepOneCallback: () =>
    console.log 'hello'

class AmoebaSite.Cube
  constructor: (parentDiv, @callback) ->
    @container = $('<div/>')
      .appendTo(parentDiv)

    @toggle = 1

    this._initializeVariables()
    this._setupCube()

    setTimeout( =>
      this._transformToCube(@popCubeTransforms)

      setTimeout( =>
        this.rotateToIndex(3)
      ,5000)

    ,2000)

  tearDown: () =>
    if @container
      @container.remove()
      @container = undefined

  rotateToIndex: (theIndex) =>
    r = @rotationSteps[theIndex]

    $("#threeDCube").transition(
      rotateX: r.x
      rotateY: r.y
      rotate: r.z
      duration: 2000
      complete: =>
        this.rotateToIndex(Math.floor(Math.random() * 5.99))

    )

  _setupCube: =>
    css =
      position: 'relative'
      width: @cubeSize
      height: @cubeSize
#        this doesn't work, but webkit-perspective does?
#        perspective: '1200px'
#        '-webkit-perspective': 1200

    _.extend(css, AmoebaSB.layout.center(@cubeSize, @cubeSize))

    stage = $('<div/>')
      .appendTo(@container)
      .addClass('somePerspective')   # perspective above didn't work, see notes in _presentation.css.scss
      .css(css)

    cube = $('<div/>')
      .appendTo(stage)
      .attr("id", "threeDCube")

    _.each([0..5], (theNum, index) =>
      @cubeFaces.push(
        $('<div/>')
          .appendTo(cube)
          .transition(_.extend({duration: 1400}, @flatTransforms[index]))
      )
    )

  _flatTransform: (index) =>
    margin = 20
    z = -2000
    x = (@container.width() - @cubeSize) / 2
    y = (@container.height() - @cubeSize) / 2

    switch(index)
      # when 0
        # already in center
      when 1
        x += @cubeSize + margin
      when 2
        x -= @cubeSize + margin
      when 3
        x -= @cubeSize + margin
        y -= @cubeSize + margin
      when 4
        x -= @cubeSize + margin
        y += @cubeSize + margin
      when 5
        x -= (@cubeSize + margin) * 2
        y += @cubeSize + margin

    result =
      transform: "translateY(#{y}px) translateX(#{x}px) translateZ(#{z}px)"

    return result

  _transformToCube: (transformArray) =>
    theDelay = 400

    # call back when the transform is done for all sizes
    count = @cubeFaces.length
    callback = () =>
      count--
      if count == 0
        if (@toggle == 1)
          @toggle = 2
          this._transformToCube(@cubeTransforms)
        else
          @toggle = 1
          this._transformToCube(@popCubeTransforms)

    _.each(@cubeFaces, (face, index) =>
      theCSS = _.extend({delay: index*theDelay}, transformArray[index])

      # add callback
      _.extend(theCSS, {complete: callback})

      # transition
      face.transition(theCSS)
    )

  _cubeTransform: (x, y, z, pop=0, spin=0) =>
    x += spin
    y += spin
    z += spin

    result =
      transform: "rotateY(#{y}deg) rotateX(#{x}deg) rotateZ(#{z}deg) translateZ(#{(@cubeSize / 2) + pop}px)"

    return result

  _initializeVariables: () =>
    @cubeSize = 420
    @cubeFaces = []

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

    @cubeTransforms = [
      this._cubeTransform(0, 90, 0)
      this._cubeTransform(90, 90, 0)
      this._cubeTransform(0, 180, 90)
      this._cubeTransform(0, -90, 90)
      this._cubeTransform(-90, 0, 0)
      this._cubeTransform(0, 0, 0)
    ]

    pop = 60
    spin = 0
    @popCubeTransforms = [
      this._cubeTransform(0, 90, 0, pop, spin)
      this._cubeTransform(90, 90, 0, pop, spin)
      this._cubeTransform(0, 180, 90, pop, spin)
      this._cubeTransform(0, -90, 90, pop, spin)
      this._cubeTransform(-90, 0, 0, pop, spin)
      this._cubeTransform(0, 0, 0, pop, spin)
    ]


    @flatTransforms = []
    _.each([0..5], (element, index) =>
      @flatTransforms.push(this._flatTransform(index))
    )


