
# global, could be removed once finalize
AmoebaSite.simpleRotation = false

class AmoebaSite.CubeScene
  constructor: (@el, @callback) ->
    @container = $('<div/>')
      .appendTo(@el)

    @el.addClass('somePerspective')

    this._initializeVariables()
    this._setupCube()

    @cube3D.css(
      opacity: 1
      scale: 1.3
    )

    # bounce up eyes from bottom
    this._bounceInEyes()


    # set background white

    # set cube to fancy

    # scale it to 1

    # message bubbles

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
      duration: 2000
      complete: =>
        this._moveCubeToCenter()
    )

  _moveCubeToCenter: =>
    setTimeout(=>
      AmoebaSite.presentation.setBackground('white')

      # make the cube more fancy
      _.each(@cubeFaces, (face, index) =>
        face.addClass('fancy')
      )

      @cube3D.transition(
        scale: 1
        duration: 1000

        complete: =>
          this._tiltLeft()
      )

    , 500)

  _tiltLeft: =>
    @cube3D.transition(
      transform: 'translateZ(-1000px) rotateX(-15deg) rotateY(-15deg) rotate(0deg)'
      duration: 1000
      complete: =>
        @typeWriterMode = 1
        this._typewriter()
    )

  _typewriter: =>
    if @typeWriterMode == 1
      @messages = [
        "Hi, I’m Amoeba"
        "I work with early stage technology companies"
        "to transform their idea into a minimum viable product"
      ]
    else if @typeWriterMode == 2
      @messages = [
        "Get it done in weeks, not months"
        "( or god forbid, years )"
      ]
    else
      @messages = [
        'How the fuck is this possible?'
        "Don't give me your Jew bullshit"
      ]

    @typewriterIndex = 0
    this._nextTypewriter()

  _nextTypewriter: =>
    message = @messages.shift()

    @typewriterIndex += 1

    startTop = 100

    if message
      height = 20
      css =
        left: '50%'
        width: 600 # can't be a percentage
        top: startTop + (height * @typewriterIndex)
        height: height

      typewriter = new AmoebaSite.Typewriter(@el, message, css)
      typewriter.write(this._nextTypewriter)
    else
      this._typewriterDone()

  _typewriterDone: =>
    if @typeWriterMode == 1
      AmoebaSite.utils.remove(true, true, ['typewriter'], @el, () =>
        this._tiltRight()
      )
    else if @typeWriterMode == 2
      this._slideInCustomer()
    else
      this._slideOutCustomer()

  _tiltRight: =>
    @cube3D.transition(
      transform: 'translateZ(-500px) rotateX(-375deg) rotateY(15deg) rotate(0deg)'
      duration: 1000
      complete: =>
        @typeWriterMode = 2
        this._typewriter();
    )

  _slideInCustomer: =>
    this._createCustomer()

    AmoebaSite.utils.remove(true, true, ['typewriter'], @el, () =>
      @customer.transition(
        transform: 'translateX(0px) translateZ(0px)'
        opacity: 1
        duration: 3000

        complete: =>
          @typeWriterMode = 3
          this._typewriter();
      )
    )

  _slideOutCustomer: =>
    AmoebaSite.utils.remove(true, true, ['typewriter'], @el, () =>
      @customer.transition(
        transform: 'translateX(-2000px) translateZ(-2000px)'
        opacity: 0
        duration: 3000

        complete: =>
          this._fadeInContentScreen()
      )
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
      .attr("id", "threeDCube")

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
    _.each(@cubeFaces, (theDiv, index) =>
      switch (index)
        when 0
          this._buildCubeSize0(theDiv)
        when 1
          this._buildCubeSize1(theDiv)
        when 2
          this._buildCubeSize2(theDiv)
        when 3
          this._buildCubeSize3(theDiv)
        when 4
          this._buildCubeSize4(theDiv)
        when 5
#          this._buildCubeSize5(theDiv)
        else
          console.log 'bad index'
    )

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
        delay: index*theDelay

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
    # message
    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Great Software\nPhilosophy", theCSS, null, sideDiv)

    sentence = 'Building great software is a delicate balance of creative vision, architecture, and engineering.'
    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)

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

  _buildCubeSize1: (sideDiv) =>
    # message
    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Logic Driven", theCSS, null, sideDiv)
    sentence = 'We build software in an agile way, ensuring that we only build the minimum product for each iteration. This allows us to constantly design, engineer, and finally get feedback on the product.'

    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)

    title.transition(
      top: 20
      left: 20
      color: 'white'
      height: 200
      width: 500
      opacity: 1
      duration: 400
    )
    message.transition(
      top: 120
      left: 20

      color: 'white'
      height: 80
      width: 500
      opacity: 1
      duration: 400
    )

    scaleImage = AmoebaSite.utils.createImageDiv('/images/presentation/gear.svg', 'cube', 160, sideDiv)
    scaleImage.transition(
      top: 'auto' # unset top set in createImageDiv
      bottom: 110
      left: 80
      opacity: 1
      duration: 400
    )

    scaleImage = AmoebaSite.utils.createImageDiv('/images/presentation/gear.svg', 'cube', 160, sideDiv)
    scaleImage.transition(
      top: 'auto' # unset top set in createImageDiv
      bottom: 0
      opacity: 1
      duration: 400
    )

    scaleImage = AmoebaSite.utils.createImageDiv('/images/presentation/gear.svg', 'cube', 160, sideDiv)
    scaleImage.transition(
      top: 'auto' # unset top set in createImageDiv
      left: 'auto'
      right: 80
      bottom: 110
      opacity: 1
      duration: 400
    )

  _buildCubeSize2: (sideDiv) =>
    # message
    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Data Driven", theCSS, null, sideDiv)

    sentence = 'We like to involve the stakeholders as well as actual users in our process, to validate our assumptions, and drive the product development. In designing a MVP we collect and use user data early in the process to help shape product decisions. Grow at different rates'
    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)

    title.transition(
      top: 20
      left: 20
      color: 'white'
      height: 200
      width: 500
      opacity: 1
      duration: 400
    )
    message.transition(
      top: 120
      left: 20

      color: 'white'
      height: 80
      width: 500
      opacity: 1
      duration: 400
    )

    graph1 = this._buildGraphDiv(100, "#{AmoebaSite.Colors.amoebaGreenDark}", sideDiv)
    graph2 = this._buildGraphDiv(220, "#{AmoebaSite.Colors.amoebaGreen}", sideDiv)
    graph3 = this._buildGraphDiv(340, "white", sideDiv)

    # add infinite animations
    graph1.keyframe('barGraphMover', 8000, 'linear', 2000, 'Infinite', 'alternate', () =>
      graph1.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )
    graph2.keyframe('barGraphMover', 8000, 'linear', 0, 'Infinite', 'alternate', () =>
      graph2.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )
    graph3.keyframe('barGraphMover', 8000, 'linear', 4320, 'Infinite', 'alternate', () =>
      graph3.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

  _buildCubeSize3: (sideDiv) =>
    # message
    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Process", theCSS, null, sideDiv)

    sentence = 'We work on an idea until a viable product merges through our lean iterative approach.'
    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)

    lightBulb = AmoebaSite.utils.createImageDiv('/images/presentation/lightbulb.svg', null, 300, sideDiv)

    title.transition(
      top: 20
      left: 20
      color: 'white'
      height: 200
      width: 500
      opacity: 1
      duration: 400
    )
    message.transition(
      top: 120
      left: 20

      color: 'white'
      height: 80
      width: 500
      opacity: 1
      duration: 400
    )

    lightBulb.transition(
      top: 200
      left: 200

      color: 'white'
      opacity: 1
      duration: 400
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

  _buildCubeSize5: (sideDiv) =>
    eyesImage = AmoebaSite.utils.createImageDiv('/images/presentation/eyes.svg', 'cube', 300, sideDiv)
    eyesImage.transition(
      opacity: 1
      duration: 1000
    )

  _buildGraphDiv: (left, color, parentDiv) =>
    result = $('<div/>')
      .appendTo(parentDiv)
      .css(
        position: 'absolute'
        height: 200
        width: 100
        bottom: 30
        left: left
        backgroundColor: color
      )

    return result

  # ====================================================
  # cube animations
  # ====================================================

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
      duration: 3000
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
      duration: 2000
      complete: =>
        setTimeout( =>
          this._fadeInContentScreen()
        , 100)
    )

  _rotationControllerCallback: () =>
    # controller is done, not needed any longer
    @rotationController = undefined

    # remove the cube interior girders
    AmoebaSite.utils.remove(false, true, ['girder'], @container, () =>

      # get the cube back to 0,0,0
      @cube3D.transition(
        rotateX: 0
        rotateY: 0
        rotate: 0
        duration: 1000
        complete: =>
          this._timedTransform(@flatTransforms)
      )
    )

  _fadeInContentScreen:() =>
    this._addContentToCube()

    setTimeout( =>
      @rotationController = new AmoebaSite.Presentation.RotationController(@cube3D, this._rotationControllerCallback)

      @rotationController.start()
    , 100)

# ===========================================================
# ===========================================================

class AmoebaSite.Presentation.RotationController
  constructor: (@cube3D, @callback) ->
    this._initializeVariables()

  start: () =>
    this._rotateCube()

  togglePause: () =>
    @paused = not @paused

    if not @paused
      this.next()

  next: () =>
    this._rotateCube(true, true)
    return true

  previous: () =>
    if @showingIndex > 0
      this._rotateCube(false, true)
      return true

    return false

  _rotateToIndex: (theIndex, fast=false) =>
    if not @cube3D?
      return

    @showingIndex = theIndex
    duration = if fast then 200 else 2000

    r = @rotationSteps[theIndex]

    @cube3D.transition(
      rotateX: r.x
      rotateY: r.y
      rotate: r.z
      duration: duration
      complete: =>
        if not @paused
          this._rotateCube(true, false)
    )

  _rotateCube: (forwards = true, fast=false) =>
      if (@showingIndex == 5)
        delay = if fast then 0 else 1000

        setTimeout( =>
          if @callback
            @callback()
        ,delay)
      else
        delay = if fast then 0 else 400

        setTimeout( =>
          theIndex = if forwards then @showingIndex + 1 else @showingIndex - 1
          this._rotateToIndex(theIndex, fast)
        , delay)

  _initializeVariables: () =>
    @showingIndex = 0
    @paused = false

    if AmoebaSite.simpleRotation
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
    else
      @rotationSteps = [
        x:0
        y:0
        z:0
      ,
        x:90
        y:0
        z:90
      ,
        x:0
        y:-90
        z:90
      ,
        x:0
        y:-180
        z:180
      ,
        x:-90
        y:-180
        z:90
      ,
        x:-90
        y:-180
        z:180
      ]

