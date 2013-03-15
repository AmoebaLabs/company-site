
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
    sentence = "As the client hires developers, we include them on our team, at our offices. As integrated team members, our client's develop- ers are trained on the processes, tools and technologies they will need to continue development after version 1.0 and beyond."

    title = AmoebaSite.utils.createTextDiv("Preparing You", 'who', 4, @el, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, 'who', 1.3, @el, 'left')

    title.css(
      top:70
      left: '50%'
    )
    title.transition(
      opacity: 1
      duration: 800
    )

    message.css(
      top:450
      left: '50%'
      width: 450
    )
    message.transition(
      opacity: 1
      duration: 800
      complete: =>
        @cube = new AmoebaSite.Cube(@el, this._stepOneCallback)
    )

  _stepOneCallback: () =>
    console.log 'hello'


# -------------------------------------------------------------------
# -------------------------------------------------------------------

class AmoebaSite.Cube
  constructor: (parentDiv, @callback) ->
    @container = $('<div/>')
      .appendTo(parentDiv)

    this._initializeVariables()
    this._setupCube()

    setTimeout( =>
      this._transformToCube(@cubeTransforms)
    ,5000)

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
        this._rotateDone()
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

      theDiv = $('<div/>')
        .appendTo(cube)
        .addClass("threeDCubeSide")
        .css(_.extend({top: 1400, left: 3000}, @flatTransforms[index]))

      this._addContentForCubeSide(index, theDiv)

      theDiv.transition(
        duration: 400
        delay: Math.random() * 400
        top:0
        left: 0
      )

      @cubeFaces.push(theDiv)
    )

  _flatTransform: (index) =>
    margin = 20
    z = -3000
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
        this._transformToCubeDone()

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
    @cubeSize = 520
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

    @flatTransforms = []
    _.each([0..5], (element, index) =>
      @flatTransforms.push(this._flatTransform(index))
    )

  _transformToCubeDone: () =>
    setTimeout( =>
      this.rotateToIndex(2)
    , 400)

  _rotateDone:() =>
    setTimeout( =>
      console.log 'duh'
    , 400)

  _addContentForCubeSide: (theIndex, sideDiv) =>
    result = null
    switch (theIndex)
      when 0
        this._buildCubeSize0(sideDiv)
      when 1
        this._buildCubeSize1(sideDiv)
      when 2
        this._buildCubeSize2(sideDiv)
      when 3
        this._buildCubeSize3(sideDiv)
      when 4
        this._buildCubeSize4(sideDiv)
      when 5
        this._buildCubeSize5(sideDiv)
      else
        console.log 'bad index'

    return result

  _buildCubeSize0: (sideDiv) =>
    eyesImage = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyesImage.css(opacity: 1)

  _buildCubeSize1: (sideDiv) =>

    # message
    title = AmoebaSite.utils.createTextDiv("Great Software\nPhilosophy", 'who', 4, sideDiv, 'left')
    sentence = 'Building great software is a delicate balance of creative vision, architecture, and engineering.'
    message = AmoebaSite.utils.createTextDiv(sentence, 'who', 1.3, sideDiv, 'left')

    title.transition(
      top: 80
      left: 20
      color: 'white'
      height: 200
      width: 500
      opacity: 1
      duration: 400
    )
    message.transition(
      top: 260
      left: 20

      color: 'white'
      height: 80
      width: 500
      opacity: 1
      duration: 400
    )

    # image at bottom
    scaleImage = AmoebaSite.utils.createImageDiv('/images/presentation/scale.svg', 'cube', 200, sideDiv)
    scaleImage.transition(
      top: 'auto' # unset top set in createImageDiv
      bottom: 0
      opacity: 1
      duration: 400
    )

  _buildCubeSize2: (sideDiv) =>
    eyes = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyes.css(opacity: 1)

  _buildCubeSize3: (sideDiv) =>
    eyes = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyes.css(opacity: 1)

  _buildCubeSize4: (sideDiv) =>
    eyes = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyes.css(opacity: 1)

  _buildCubeSize5: (sideDiv) =>
    eyes = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyes.css(opacity: 1)


