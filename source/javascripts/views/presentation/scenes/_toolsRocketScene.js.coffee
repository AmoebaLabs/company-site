
class AmoebaSite.ToolsRocketScene
  constructor:(@el, @callback) ->
    @animationIndex = 0
    @endLocationTop = 220
    @endLocationLeft = 154
    @toolTopOffset = 30
    @rotateTransformOrigin = '28% bottom 0'

    this._createRocket()
    this._createMascot()

  start: =>
    this._showRocket()
    this._setNextAnimationTimer()

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
      opacity: 1
    )

    @rocketContainer.keyframe('bounceInUp', 800, 'ease-out', 0, 1, 'normal', () =>
      @rocketContainer.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
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
        top: 50
        left: 50
        height: '180%'
        width: AmoebaSB.layout.slideWidth - 100
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

        height: '18%'
        width: '100%'
      )

    @rocket = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_body_only.svg" + '")'
        backgroundPosition: 'center top'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '58%'
        width: '100%'
        transform: 'translateZ(0px)'     # needed for zIndex to work? not sure why
      )

    @rocketFlame = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_flame_only.svg" + '")'
        backgroundPosition: 'center top'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '24%'
        width: '100%'
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
          this._popoutMascot()
        when 2
          this._swingLidClosed()
        when 3
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
        height: 140
        width: 140
        zIndex: -1
        opacity: 0
      )

  _popoutMascot: =>
    @mascot.css(
      top: @endLocationTop
      left: @endLocationLeft - 20

      opacity: 1
    )

    @mascot.transition(
      top: @toolTopOffset + 15
      duration: AmoebaSite.utils.dur(1500)
      easing: 'in'
      complete: =>
        @mascot.transition(
          top: @endLocationTop
          duration: AmoebaSite.utils.dur(1000)
          delay: AmoebaSite.utils.dur(500)
          easing: 'in'
          complete: =>
            this._setNextAnimationTimer(200)
        )
    )
