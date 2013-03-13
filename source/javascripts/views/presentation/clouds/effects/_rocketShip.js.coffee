
class AmoebaSite.RocketShip extends AmoebaSite.EffectsBase
  # called from base classes constructor
  setup:() =>

    @duration = 4000

    # making it large so we don't get pixels when scaling up from a smaller size
    @shipWidth = 600
    @shipHeight = 1200

    # should make rocket go between some clouds
    @rocketZ = '1px'
    @rocketZInFront = '200px'
    fragment = document.createDocumentFragment();

    this._buildShip(fragment)

    @containerDiv[0].appendChild(fragment);

    this._runShipAnimation()

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

  # =======================================================================================
  # =======================================================================================
  # Rocket Animation

  _runShipAnimation: () =>
    # shake rocket to look more real
    @shipDiv.css(
      transformOrigin: '50% 0%'
    )

    @shipDiv.keyframe('rocketShake', 100, 'linear', 0, 'Infinite', 'normal', () =>
      @shipDiv.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

    steps = [this._rocketStep1, this._rocketStep2, this._rocketStep3, this._rocketStep4, this._rocketStep5]

    this._runRocketAnimations(steps)

  _runRocketAnimations: (steps, transitionID=0) =>
    if steps.length
      nextStep = steps.shift()

      nextStep(steps)

      if transitionID > 0
        if @callback?
          @callback(transitionID)
    else
      if @callback?
        @callback(10)  # 10 means we are done, tear it down

  _rocketStep1: (steps) =>
    @rocketShip.css(
      scale:.8
      left: @containerDiv.width()
      top: @containerDiv.height()
      transform: "rotate(-25deg) translateZ(#{@rocketZ})"
    )
    @rocketShip.transition(
      top: -300
      left: @containerDiv.width() / 4
      duration: @duration
      scale:.4

      complete: =>
        this._runRocketAnimations(steps)
    )

  _rocketStep2: (steps) =>
    @rocketShip.transition(
      top: 0
      left: 0
      transform: "rotate(0deg) translateZ(#{@rocketZInFront})"
      scale:.8
      duration: @duration

      complete: =>
        this._runRocketAnimations(steps)
    )

  _rocketStep3: (steps) =>
    @rocketShip.transition(
      transform: "rotate(25deg) translateZ(#{@rocketZ})"
      top: @containerDiv.height()
      left: @containerDiv.width()
      duration: @duration
      scale:.1

      complete: =>
        this._runRocketAnimations(steps, 1) # 1 signals to send a callback event with id = 1
    )

  _rocketStep4: (steps) =>
    @rocketShip.css(
      transform: "rotate(0deg) translateZ(#{@rocketZ})"
      top: 1000
      left: (@containerDiv.width() - @shipWidth) / 2
      duration: @duration
      scale: 1
    )
    @rocketShip.transition(
      top: -1000
      left: (@containerDiv.width() - @shipWidth) / 2
      duration: @duration
      scale:.2
      complete: =>
        this._runRocketAnimations(steps)
    )

  _rocketStep5: (steps) =>
    @rocketShip.css(
      transform: "rotate(35deg) translateZ(#{@rocketZ})"
      top: -500
      left: -400
      duration: @duration
      scale: .1
      opacity: .1
    )
    @rocketShip.transition(
      top: -80
      left: -260
      duration: @duration * 2
      opacity: 1
      scale: 1
      complete: =>
        this._runRocketAnimations(steps)
    )
