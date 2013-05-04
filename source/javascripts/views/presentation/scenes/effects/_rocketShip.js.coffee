
class AmoebaSite.RocketShip
  constructor: (parentDiv, @shipWidth, @shipHeight) ->
    @fps = 24
    @stopped = false
    @numExpectedCallbacks = 0

    this._buildShip(parentDiv)

  start: =>
    this._startShakeAnimation()
    this._startExhaustAnimation()

  tearDown: =>
    @rocketShip?.remove()
    @rocketShip = undefined

  css: (theParams) =>
    @rocketShip.css(theParams)
    return this # chainable

  transition: (theParams) =>
    @rocketShip.transition(theParams)
    return this # chainable

  _startShakeAnimation: =>
    # shake rocket to look more real
    @shipDiv.css(
      transformOrigin: '50% 0%'
    )

    @shipDiv.keyframe('rocketShake', 100, 'linear', 0, 'Infinite', 'normal', () =>
      @shipDiv.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

  _startExhaustAnimation: =>
    delay = 0
    _.each(@exhaustClouds, (cloud, index) =>
      this._runExhaustAnimation(cloud, delay)
      delay += 90
    )

  _runExhaustAnimation: (cloud, delay) =>
    numClouds = @exhaustClouds.length

    # set the starting point for the transition
    cloud.applyCSS(
      opacity: 1
      display: 'block' # display : none is set at end of transition
      left: '50%'
      top: 30
      # clouds by default are translated x,y on creation, so this returns it back to zero
      transform: 'translateX(0px) scale(0.2) translateY(0px)'
    )

    # don't use the complete: callback since that will get called for
    # every layer this transition is applied to. Send callback to applyCSS
    transitionCallback = () =>
      @numExpectedCallbacks--
      if not @stopped
        this._runExhaustAnimation(cloud, 10)  # loops until stopped
      else
        if @numExpectedCallbacks == 0
          this._tearDown()

    @numExpectedCallbacks++
    duration = 300
    cloud.animateCSS(
      top: 233
      scale: 0.6
      opacity: 0.4
      duration: duration
      delay: delay
      complete: transitionCallback
    )

  _buildShip: (parentDiv) =>
    shipImage = "/images/presentation/rocket.svg"

    @rocketShip = $('<div/>')
      .appendTo(parentDiv)
      .css(
        position: 'absolute'
        top: 0
        left: 0
        width: @shipWidth
        height: @shipHeight
      )
    @shipDiv = $('<div/>')
      .appendTo(@rocketShip)
      .css(
        position: 'absolute'
        top: 0
        left: 0
        width: '100%'
        height: '40%'
        backgroundImage: 'url("' + shipImage + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
      )
    fireDiv = $('<div/>')
      .appendTo(@rocketShip)
      .css(
        position: 'absolute'
        top: '40%'
        left: 0
        width: '100%'
        height: '60%'
      )

    this._addExhaustClouds(fireDiv)

  _addExhaustClouds: (parentDiv) =>
    @exhaustClouds = [
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('bay'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('fire'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('fire'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('bay'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('fire'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('fire'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('bay'), @fps)
      new AmoebaSite.Cloud(parentDiv, AmoebaSite.textures.weightedTextures('bay'), @fps)
    ]
