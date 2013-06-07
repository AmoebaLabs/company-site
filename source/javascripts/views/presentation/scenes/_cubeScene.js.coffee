
# global, could be removed once finalize
AmoebaSite.simpleRotation = false

class AmoebaSite.CubeScene
  constructor: (@el, @callback) ->
    AmoebaSite.presentation.setBackgroundColor(AmoebaSite.Colors.amoebaGreenMedium)

    @container = $('<div/>')
      .appendTo(@el)

    @el.addClass('somePerspective')

    this._initializeVariables()
    this._setupCube()

    @cube3D.css(
      opacity: 1
      scale: 1.3
    )

    this._bounceInEyes()

  tearDown: () =>
    @container?.remove()
    @container = undefined

    @cube3D = undefined
    @rotationController = undefined

  pause: () =>
    if @rotationController
      @rotationController.togglePause()
      return true

    return false

  next: () =>
    if @rotationController
      return @rotationController.next()

    return false

  previous: () =>
    if @rotationController
      return @rotationController.previous()

    return false

  _bounceInEyes: =>
    sideDiv = @cubeFaces[5]
    eyesImage = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyesImage.transition(
      opacity: 1
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        this._moveCubeToCenter()
    )

  _moveCubeToCenter: =>
    setTimeout(=>
      AmoebaSite.presentation.setBackground('default')

      # make the cube more fancy
      _.each(@cubeFaces, (face, index) =>
        face.addClass('fancy')
      )

      @cube3D.transition(
        scale: 1
        duration: AmoebaSite.utils.dur(1000)

        complete: =>
          this._tiltLeft()
      )

    , AmoebaSite.utils.dur(500))

  _tiltLeft: =>
    @cube3D.transition(
      transform: 'translateZ(-1000px) rotateX(-15deg) rotateY(-15deg) rotate(0deg)'
      duration: AmoebaSite.utils.dur(1000)
      complete: =>
        this._typewriter(1)
    )

  _typewriter: (conversationIndex) =>
    left = 10

    if conversationIndex == 1
      messages = [
        "Hi, I’m Amoeba"
        "I work with early stage technology companies"
        "to transform their idea into a minimum viable product"
      ]
    else if conversationIndex == 2
      messages = [
        "Get it done in weeks, not months"
        "( or god forbid, years )"
      ]
    else
      left = 500

      messages = [
        'How the fuck is this possible?'
        "I don't believe it."
      ]

    positionCSS =
      top: 10
      left: left
      height: 100
      width: 400

    @speechBubble = new AmoebaSite.SpeechBubble(@el, messages, positionCSS, conversationIndex, this._speechBubbleCallback)
    @speechBubble.start()

  _speechBubbleCallback: (conversationIndex) =>
    if @speechBubble?
      @speechBubble.tearDown()
      @speechBubble = undefined

    if conversationIndex == 1
      this._tiltRight()
    else if conversationIndex == 2
      this._slideInCustomer()
    else
      this._slideOutCustomer()

  _tiltRight: =>
    @cube3D.transition(
      transform: 'translateZ(-500px) rotateX(-375deg) rotateY(15deg) rotate(0deg)'
      duration: AmoebaSite.utils.dur(1000)
      complete: =>
        conversationIndex = 2
        this._typewriter(2);
    )

  _slideInCustomer: =>
    this._createCustomer()

    @customer.transition(
      transform: 'translateX(0px) translateZ(0px)'
      opacity: 1
      duration: AmoebaSite.utils.dur(3000)

      complete: =>
        this._typewriter(3);
    )

  _slideOutCustomer: =>
    @customer.transition(
      transform: 'translateX(-2000px) translateZ(-2000px)'
      opacity: 0
      duration: AmoebaSite.utils.dur(3000)

      complete: =>
        this._fadeInContentScreen()
    )

  _createCustomer: =>
    if not @customer?
      @customer = $('<img/>')
        .attr(src: '/images/presentation/space_mascot.svg')
        .appendTo(@el)
        .css(
          position: 'absolute'
          top: 250
          right: 0
          height: 260
          width: 260
          transform: 'translateX(1000px) translateZ(-1000px)'
          opacity: 0
        )

  _rollRollCubeOut:() =>
    if not @cube3D?
      return

    @cube3D.css(
      opacity:1
    )

    @cube3D.transition(
      opacity:.3
      transform: "translateZ(-5200px) rotateX(0deg) rotateY(0deg) rotate(0deg)"
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        this._rollRollCubeDown()
    )

  _rollRollCubeDown:() =>
    if not @cube3D?
      return

    @cube3D.transition(
      transform: "translateY(4000px) translateZ(-5200px) rotateX(0deg) rotateY(720deg) rotate(0deg)"
      duration: AmoebaSite.utils.dur(6000)
      complete: =>
        if @callback?
          @callback()
    )

  _fadeInContentScreen:() =>
    this._addContentToCube()

    setTimeout( =>
      @rotationController = new AmoebaSite.CubeRotationController(@cube3D, =>
        # controller is done, not needed any longer
        @rotationController = undefined
        this._rollRollCubeOut()
      )

      @rotationController.start()
    , AmoebaSite.utils.dur(100))

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

    @cube3D = $('<div/>')
      .appendTo(stage)
      .addClass("threeDCube")

    this._buildOuterCube()
    this._buildInnerCube()

  _buildOuterCube: () =>
    _.each([0..5], (theNum, index) =>
      theDiv = $('<div/>')
        .appendTo(@cube3D)
        .addClass("threeDCubeSide")
        .css(@cubeTransforms[index])

      @cubeFaces.push(theDiv)
    )

  _addContentToCube: () =>
    this._buildCubeSize0(@cubeFaces[0])
    this._buildCubeSize4(@cubeFaces[1])

  _buildInnerCube: () =>
    transforms = this._girderTransform()
    cnt = transforms.length

    _.each([0...cnt], (theNum, index) =>
      theDiv = $('<div/>')
        .appendTo(@cube3D)
        .css(transforms[index])
        .addClass("innerCubeSide girder")

      $('<div/>')
        .appendTo(theDiv)
        .addClass("ics")
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

  _timedTransform: (transformArray) =>
    theDelay = 400

    # call back when the transform is done for all sizes
    count = @cubeFaces.length
    callback = () =>
      count--
      if count == 0
        _.each(@cubeFaces, (face, index) =>
          face.css(
            boxShadow: '5px 5px 40px black'
          )
        )

        this._stepDone('cubeTransformDone')

    _.each(@cubeFaces, (face, index) =>
      moreCSS =
        delay: AmoebaSite.utils.dur(index*theDelay)

      theCSS = _.extend(moreCSS, transformArray[index])

      # add callback
      _.extend(theCSS, {complete: callback})

      # transition
      face.transition(theCSS)
    )

  _cubeTransform: (x, y, z, translateZ = 0) =>
    transZ = (@cubeSize / 2) + translateZ

    result =
      transform: "rotateY(#{y}deg) rotateX(#{x}deg) rotateZ(#{z}deg) translateZ(#{transZ}px)"

    return result

  _initializeVariables: () =>
    @cubeSize = 520
    @cubeFaces = []

    if AmoebaSite.simpleRotation
      @cubeTransforms = [
        this._cubeTransform(0, 90, 0)
        this._cubeTransform(90, 90, 0)
        this._cubeTransform(0, 180, 90)
        this._cubeTransform(0, -90, 90)
        this._cubeTransform(-90, 0, 0)
        this._cubeTransform(0, 0, 0)
      ]
    else
      @cubeTransforms = [
        this._cubeTransform(0, 90, -90)
        this._cubeTransform(90, 90, 0)
        this._cubeTransform(0, 180, 180)
        this._cubeTransform(0, -90, 90)
        this._cubeTransform(-90, 0, 0)
        this._cubeTransform(0, 0, 0)
      ]

    @flatTransforms = []
    _.each([0..5], (element, index) =>
      @flatTransforms.push(this._flatTransform(index))
    )

  _girderTransform: () =>
    safari = true

    if safari
      result = [
        this._cubeTransform(0, 90, 0, -(@cubeSize / 2))
        this._cubeTransform(90, 0, 0, -(@cubeSize / 2))
        this._cubeTransform(0, 0, 0, -(@cubeSize / 2))
      ]
    else
      inset = -20
      result = [
        this._cubeTransform(0, 90, 0, inset)
        this._cubeTransform(90, 90, 0, inset)
        this._cubeTransform(0, 180, 90, inset)
        this._cubeTransform(0, -90, 90, inset)
        this._cubeTransform(-90, 0, 0, inset)
        this._cubeTransform(0, 0, 0, inset)
      ]

    return result

  _stepDone: (stepID) =>
    switch (stepID)
      when 'cubeTransformDone'
        @callback()

  _buildCubeSize0: (sideDiv) =>
    sentence = "Building great software doesn't have to be rocket science."
    theCSS = AmoebaSite.utils.textCSSForSize(2.3, 'left')
    title = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)

    title.transition(
      top: 80
      left: 20
      color: 'white'
      height: 200
      width: 500
      opacity: 1
      duration: AmoebaSite.utils.dur(400)
    )

    # image at bottom
    scaleImage = AmoebaSite.utils.createImageDiv('/images/presentation/rocket.svg', 'cube', 200, sideDiv)
    scaleImage.transition(
      top: 'auto' # unset top set in createImageDiv
      bottom: 0
      opacity: 1
      duration: AmoebaSite.utils.dur(400)
    )

  _buildCubeSize4: (sideDiv) =>
    $('<div/>')
      .html('Amoeba<sup style="vertical-align: super; font-size: 0.2em;">\u2120</sup>')   # vertical-align: super is the magic that makes this work
      .appendTo(sideDiv)
      .addClass("amoebaBoldFont")
      .css(
        fontSize: "8em"
        position: "absolute"
        textAlign: "center"
        top: 120
        left: 0
        width: "100%"
        color: 'white'
      )

    info = [
      "Amoeba Consulting, LLC"
    ,
      "Email: <a href='mailto:sayhi@amoe.ba'>sayhi@amoe.ba</a>"
    ,
      "Phone: 1+(415)444-5544"
    ,
      "<a href='www.amoe.ba'>www.amoe.ba</a>"
    ]

    info = info.join("<br>")

    $('<div/>')
      .html(info)
      .appendTo(sideDiv)
      .addClass("amoebaBoldFont")
      .css(
        fontSize: "1em"
        position: "absolute"
        textAlign: "center"
        top: 320
        left: 0
        width: "100%"
        color: 'black'
      )

  _cubeDownToScreen:() =>
    if not @cube3D?
      return

    @cube3D.css(
      opacity:.3
      transform: 'translateY(4000px) translateZ(-5200px) rotateX(460deg) rotateY(760deg)'
    )

    @cube3D.transition(
      opacity: 1
      transform: 'translateY(0px) translateZ(-5200px) rotateX(360deg) rotateY(60deg)'
      duration: AmoebaSite.utils.dur(3000)
      complete: =>
        this._rollDiceToScreen()
    )

  _rollDiceToScreen:() =>
    if not @cube3D?
      return

    @cube3D.css(
      opacity:1
      transform: 'translateZ(-5200px) rotateX(360deg) rotateY(60deg)'
    )

    @cube3D.transition(
      opacity: 1
      transform: 'translateZ(0px) rotateX(0deg) rotateY(0deg)'
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        setTimeout( =>
          this._fadeInContentScreen()
        , AmoebaSite.utils.dur(100))
    )

