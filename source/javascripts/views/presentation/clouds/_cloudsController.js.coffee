class AmoebaSite.CloudsController
  constructor:(parentDiv, @doneCallback) ->
    # create this to host the 3d world div
    @viewPort = $("<div/>")
      .attr(id: 'viewport')
      .appendTo(parentDiv)

    # used for messages or anthing else
    @contentDiv = $("<div/>")
      .addClass('effectsStage')
      .appendTo(@viewPort)

    @fps = 24

    AmoebaSite.textures ?= new AmoebaSite.Textures()
    this._setupRAF()

    @cloudWorld = new AmoebaSite.CloudWorld(@viewPort, @fps)
    @cloudWorld.generate()
    @cloudWorld.toggleRotateWorld()

    this._showFallingClouds()
    this._showRocketShip()
    this._createStarsAndPlanet()
    this._showMessage(0)

  _showMessage: (messageIndex) =>
    switch (messageIndex)
      when 0
        theText = "Light-up your Start-up"
      when 1
        theText = "and Blast off!"
      when 2
        theText = "Leap ahead of the pack"
      when 3
        theText = "Preparing you for growth"
      when 4
        theText = "Rule the universe"
      when 5
        theText = "Don't be a douche"

    if theText?
      theCSS = _.extend({}, AmoebaSite.utils.deepTextShadowCSS())
      theCSS = _.extend(theCSS, AmoebaSite.utils.textCSSForSize(4))
      message = AmoebaSite.utils.createTextDiv(theText, theCSS, 'message', @contentDiv)

      message.css(
        top: 200
        left: 0
        transform: 'translateZ(-3000px) rotateY(0deg)'
      )
      message.transition(
        duration: 2000
        opacity: 1
        transform: 'translateZ(100px) rotateY(0deg)'

        complete: =>
          message.transition(
            delay: 800
            duration: 1000
            opacity: 0

            complete: =>
              # remove the message from the DOM
              $('.message').remove()

              this._showMessage(messageIndex+1)
          )
      )

  tearDown: () =>
    # stop any timed actions from happening
    @stopped = true

    if @cloudWorld?
      @cloudWorld.tearDown()
      @cloudWorld = undefined

    if @fallingClouds?
      @fallingClouds.stop()
      @fallingClouds = undefined

    if @rocketShip?
      @rocketShip.stop()
      @rocketShip = undefined

    # remove any running animation
    @$bigStars?.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    @$bigStars = undefined

    # remove any running animation
    @$smallStars?.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    @$smallStars = undefined

    @viewPort?.remove()
    @viewPort = undefined
    @$planet = undefined

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

  _showFallingClouds: () =>
    if @fallingClouds?
      @fallingClouds.stop()
      @fallingClouds = undefined

    @fallingClouds = new AmoebaSite.FallingClouds(@viewPort, @fps)

  _showRocketShip: () =>
    @rocketShip = new AmoebaSite.RocketShip(@viewPort, @fps, (animationStep) =>
      # break out if we have been torn down
      if @stopped
        return

      switch (animationStep)
        when 1  # called on final rocket blast off, fly world out
          @cloudWorld?.transitionDown()

          # stop falling clouds
          @fallingClouds?.stop()
          @fallingClouds = undefined

          # slowly fade in the planet
          @$planet?.transition(
            opacity: 1
            scale: 1
            duration: 7000
          )

          # slowly fade in the stars
          @$bigStars?.transition(
            opacity: 1
            duration: 7000

            complete: =>
              @$bigStars?.keyframe('starFlicker', 300000, 'linear', 0, 'Infinite', 'alternate', () =>
                @$bigStars?.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
              )
          )

          @$smallStars?.transition(
            opacity: 1
            duration: 7000

            complete: =>
              @$smallStars?.keyframe('starFlicker', 1000000, 'linear', 500, 'Infinite', 'alternate', () =>
                @$smallStars?.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
              )
          )

        when 10  # done, tear it down
          # stop rocket
          @rocketShip?.stop()
          @rocketShip = undefined

          # slide is done, autoadvance to next
          if @doneCallback?
            @doneCallback()
    )

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

