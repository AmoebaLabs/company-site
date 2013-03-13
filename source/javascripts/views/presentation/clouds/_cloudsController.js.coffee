class AmoebaSite.CloudsController
  constructor:() ->
    @viewPort = $("#viewport")
    @fps = 24

    AmoebaSite.textures = new AmoebaSite.Textures()
    AmoebaSite.cloudWorld = new AmoebaSite.CloudWorld(@fps)

    AmoebaSite.cloudWorld.generate()

    # this._addEventHandlers()
    this._setupRAF()
    # this._setupEventListenersToMoveWorld()

    # rotate world slowly
    AmoebaSite.cloudWorld.toggleRotateWorld()

    this.showFallingClouds()
    this.showRocketShip()
    this._createStarsAndPlanet()

  _createStarsAndPlanet: () =>
    @$planet = $("<img/>")
      .attr(src: "/images/presentation/planet.svg")
      .css(
        position: 'absolute'
        height: 500
        width: 500
        top: 0
        right: 0
        opacity: 0
        scale: 0.8
      )
      .appendTo(@viewPort)

    @$bigStars = $("<div/>")
      .css(
        background: "url('/images/presentation/starsBig.png') repeat 5% 5%"
        position: 'absolute'
        height: '100%'
        width: '100%'
        top: 0
        left: 0
        zIndex: -1
        opacity: 0
      )
      .appendTo(@viewPort)

    @$smallStars = $("<div/>")
      .css(
        background: "url('/images/presentation/starsSmall.png') repeat 35% 35%"
        position: 'absolute'
        height: '100%'
        width: '100%'
        top: 0
        left: 0
        opacity: 0
        zIndex: -1
      )
      .appendTo(@viewPort)

  showFallingClouds: () =>
    if @fallingClouds?
      @fallingClouds.stop()
      @fallingClouds = undefined

    @fallingClouds = new AmoebaSite.FallingClouds(@viewPort, @fps)

  showRocketShip: () =>
    rocketShip = new AmoebaSite.RocketShip(@viewPort, @fps, (animationStep) =>
      switch (animationStep)
        when 1  # called on final rocket blast off, fly world out
          AmoebaSite.cloudWorld.transitionDown()

          # stop falling clouds
          if @fallingClouds?
            @fallingClouds.stop()
            @fallingClouds = undefined

          # slowly fade in the planet
          @$planet.transition(
            opacity: 1
            scale: 1
            duration: 7000
          )

          # slowly fade in the stars
          @$bigStars.transition(
            opacity: 1
            duration: 7000
          )

          @$smallStars.transition(
            opacity: 1
            duration: 7000
          )

          @$bigStars.keyframe('starFlicker', 300000, 'linear', 0, 'Infinite', 'alternate', () =>
            @$bigStars.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
          )
          @$smallStars.keyframe('starFlicker', 1000000, 'linear', 500, 'Infinite', 'alternate', () =>
            @$smallStars.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
          )

        when 10  # done, tear it down
          # stop rocket
          rocketShip.stop()
          rocketShip = undefined
    )

  _addEventHandlers: () =>
    window.addEventListener "keydown", (e) =>
      # keycodes are always the uppercase character's ascii code
      switch (e.keyCode)
        when 32
          AmoebaSite.cloudWorld.generate()
        when 68  # 'd' key
          AmoebaSite.cloudWorld.hyperspace()
        when 69  # 'e' key
          AmoebaSite.cloudWorld.zoomWorld()
        when 70  # 'f' key
          this.showFallingClouds()
        when 71  # 'g' key
          AmoebaSite.cloudWorld.reversehyperspace()
        when 72
          this.showRocketShip()
        when 73
          AmoebaSite.cloudWorld.toggleRotateWorld()
#        else
#          console.log("keyCode: #{e.keyCode}")

  # requestAnimationFrame polyfill
  _setupRAF: () =>
    vendors = ["ms", "moz", "webkit", "o"]

    unless window.requestAnimationFrame
      _.each(vendors, (prefix, index) =>
        window.requestAnimationFrame = window[prefix + "RequestAnimationFrame"]
        window.cancelRequestAnimationFrame = window[prefix + "CancelRequestAnimationFrame"]

        # return breaks out of _.each
        return if window.requestAnimationFrame
      )

    unless window.requestAnimationFrame
      window.requestAnimationFrame = (callback, element) ->
        currTime = new Date().getTime()
        timeToCall = Math.max(0, 16 - (currTime - @lastTime))
        id = window.setTimeout(->
          callback currTime + timeToCall
        , timeToCall)
        @lastTime = currTime + timeToCall
        id

    unless window.cancelAnimationFrame
      window.cancelAnimationFrame = (id) ->
        clearTimeout id

  _setupEventListenersToMoveWorld: () =>
    orientationhandler = (e) ->
      [xAngle, yAngle, zTranslate] = AmoebaSite.cloudWorld.worldState()

      if not e.gamma and not e.beta
        e.gamma = -(e.x * (180 / Math.PI))
        e.beta = -(e.y * (180 / Math.PI))
      x = e.gamma
      y = e.beta
      xAngle = y
      yAngle = x
      AmoebaSite.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    # window.addEventListener( 'deviceorientation', orientationhandler, false );
    # window.addEventListener( 'MozOrientation', orientationhandler, false );

    onContainerMouseWheel = (event) =>
      [xAngle, yAngle, zTranslate] = AmoebaSite.cloudWorld.worldState()

      event = (if event then event else window.event)
      zTranslate = zTranslate - ((if event.detail then event.detail * -5 else event.wheelDelta / 8))
      AmoebaSite.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    window.addEventListener "mousewheel", onContainerMouseWheel
    window.addEventListener "DOMMouseScroll", onContainerMouseWheel

    window.addEventListener "mousemove", (e) =>
      # alternate calculation
      # xAngle = -(.1 * ( e.clientY - .5 * window.innerHeight ))
      # yAngle = .1 * ( e.clientX - .5 * window.innerWidth )

      [xAngle, yAngle, zTranslate] = AmoebaSite.cloudWorld.worldState()

      yAngle = -(.5 - (e.clientX / window.innerWidth)) * 180
      xAngle = (.5 - (e.clientY / window.innerHeight)) * 180

      AmoebaSite.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)

    window.addEventListener "touchmove", (e) =>
      [xAngle, yAngle, zTranslate] = AmoebaSite.cloudWorld.worldState()

      _.each(e.changedTouches, (touch, index) =>
        yAngle = -(.5 - (touch.pageX / window.innerWidth)) * 180
        xAngle = (.5 - (touch.pageY / window.innerHeight)) * 180
        AmoebaSite.cloudWorld.updateWorld(xAngle, yAngle, zTranslate)
      )

      e.preventDefault()

