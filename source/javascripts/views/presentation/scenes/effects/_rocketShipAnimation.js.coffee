class AmoebaSite.RocketShipAnimation extends AmoebaSite.EffectsBase
  # called from base classes constructor
  setup:() =>

    @duration = AmoebaSite.utils.dur(4000)

    # making it large so we don't get pixels when scaling up from a smaller size
    @shipWidth = 600
    @shipHeight = 1200

    # should make rocket go between some clouds
    @rocketZ = '-50px'
    @rocketZInFront = '50px'
    fragment = document.createDocumentFragment();

    @rocketShip = new AmoebaSite.RocketShip(fragment, @shipWidth, @shipHeight)
    @rocketShip.start()

    @containerDiv[0].appendChild(fragment);

    this._runShipAnimation()

  _runShipAnimation: () =>
    steps = [this._rocketStep1, this._rocketStep2, this._rocketStep3, this._rocketStep4, this._rocketStep5]

    this._runRocketAnimations(steps)

  _runRocketAnimations: (steps, transitionID=0) =>
    if @stopped
      return

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
      top: -400
      left: -300
      duration: @duration
      scale: 0
      opacity: 0.8
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
