
class AmoebaSite.ToolsRocketScene
  constructor:(@el, @callback) ->
    @animationIndex = 0
    @rotateTransformOrigin = '28% bottom 0'

    this._createRocket()
    this._createMascot()

  start: =>
    this._showRocket()

  tearDown: =>
    # cancel the animation timers if set to run
    if @animationTimeout?
      clearTimeout(@animationIndex)
      @animationTimeout = undefined

    @animationIndex = 0

    this._swingLidClosed(false) # close the lid if opened

    @rocketContainer.css(opacity: 0)
    @mascot.css(opacity: 0)

  _showRocket: () =>
    @rocketContainer.css(
      opacity: 0
      y: -window.innerHeight * 3
    )

    @rocketContainer.transition(
      opacity: 1
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        @rocketContainer.transition(
          y: 0
          duration: AmoebaSite.utils.dur(8000)
          complete: =>
            this._setNextAnimationTimer()
        )
    )

  _blastOffRocket: () =>
    @mascot.css(opacity: 0)

    @rocketContainer.css(
      opacity: 1
    )

    @rocketContainer.keyframe('bounceOutUp', 800, 'ease-out', 0, 1, 'normal', () =>
      @rocketContainer.css(
        opacity: 0
      )
      @rocketContainer.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )
    this._setNextAnimationTimer()

  _createRocket: () =>
    @rocketContainer = $('<div/>')
      .appendTo(@el)
     .css(
        position: 'absolute'
        top: 100
        left: 0
        height: '400%'
        width: AmoebaSB.layout.slideWidth
        opacity: 0
      )

    @rocketLid = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_top_only.svg" + '")'
        backgroundPosition: 'center bottom'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'

        # without this, the first rotation is off a bit, not sure why
        transformOrigin: @rotateTransformOrigin

        height: '12%'
        width: '100%'
      )

    @rocket = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_logos_no_top.svg" + '")'
        backgroundPosition: 'center top'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '88%'
        width: '100%'
        transform: 'translateZ(0px)'     # needed for zIndex to work? not sure why
      )

  _swingLidOpen: =>
    @rocketLid.transition(
      transformOrigin: @rotateTransformOrigin
      transform: 'rotate(-125deg)'
    )
    this._setNextAnimationTimer()

  _swingLidClosed: (animate=true) =>
    if animate
      @rocketLid.transition(
        transformOrigin: @rotateTransformOrigin
        transform: 'rotate(0deg)'
      )

      this._setNextAnimationTimer()
    else
      # called on slideOut to reset things back to normal
      @rocketLid.css(
        transformOrigin: @rotateTransformOrigin
        transform: 'rotate(0deg)'
      )

  _setNextAnimationTimer: (delayTime = 1200) =>
    @animationTimeout = setTimeout( =>
      @animationTimeout = undefined

      # don't continue unless the active slide
      switch @animationIndex
        when 0
          this._swingLidOpen()
        when 1
          this._popoutMascot(true)
        when 2
          this._mascotTalks()
        when 3
          this._popoutMascot(false)
        when 4
          this._swingLidClosed()
        when 5
          this._blastOffRocket()
        else
          this._finalStep()

      @animationIndex++
    , AmoebaSite.utils.dur(delayTime))

  _finalStep: =>
    @animationIndex = -1

    if @callback?
      @callback()

  _createMascot: =>
    @mascot = $('<img/>')
      .attr(src: '/images/presentation/space_mascot.svg')
      .appendTo(@el)
      .css(
        position: 'absolute'
        height: 340
        width: 340
        zIndex: -1
        opacity: 0
      )

  _popoutMascot: (show) =>
    top = 190
    left = 308
    startTop = top + 400

    if show
      @mascot.css(
        top: startTop
        left: left

        opacity: 1
      )
    else
      # already showing and in the right position, just move down
      top = startTop

    @mascot.transition(
      top: top
      duration: AmoebaSite.utils.dur(1500)
      easing: 'in'
      complete: =>
        @mascot.transition(
          top: top
          duration: AmoebaSite.utils.dur(1000)
          delay: AmoebaSite.utils.dur(500)
          easing: 'in'
          complete: =>
            this._setNextAnimationTimer(200)
        )
    )

  _mascotTalks: =>
    left = 420
    top = 20
    arrowStyle = 'left'

    positionCSS =
      position: 'absolute'  # for some reason fixed is not working in this div?
      top: top
      left: left
      height: 100
      width: 300

    speechBubble = new AmoebaSite.SpeechBubble(@el, "Ready for lift off?", positionCSS, 0, arrowStyle, =>
      setTimeout(=>
        speechBubble.tearDown()
        speechBubble = undefined

        this._setNextAnimationTimer()
      , AmoebaSite.utils.dur(1000))
    )
    speechBubble.start()



#    sentence = "Building great software doesn't have to be rocket science."
#    theCSS = AmoebaSite.utils.textCSSForSize(2.3, 'left')
#    title = AmoebaSite.utils.createTextDiv(sentence, theCSS, null, sideDiv)
