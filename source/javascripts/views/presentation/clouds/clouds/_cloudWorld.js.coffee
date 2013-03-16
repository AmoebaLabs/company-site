class AmoebaSite.CloudWorld
  constructor:(@world, @fps, @numClusters=5, @preset='current') ->

    @clouds = []
    @translateZ = 0
    @worldXAngle = 0
    @worldYAngle = 0
    @stopAnimationLoop = false

    this._animate()  # starts the requestAnimationFrame loop

  tearDown: () =>
    @stopAnimationLoop = true  # must stop the requestAnimationFrame loop otherwise it cancels out this transition

  generate: (clearWorld=true) =>
    if clearWorld
      @world.empty()

    @clouds = []
    for i in [0...@numClusters]
      @clouds.push(new AmoebaSite.Cloud(@world, AmoebaSite.textures.weightedTextures(@preset), @fps))

  worldState: () =>
    return [@worldXAngle, @worldYAngle, @translateZ]

  updateWorld:(worldXAngle, worldYAngle, translateZ) =>
    @worldXAngle = worldXAngle
    @worldYAngle = worldYAngle
    @translateZ = translateZ

    @translateWorld = true

  applyCSS: (css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSS(cssCopy)
    )

  animateCSS: (callback, css, hideWhenDone=false) =>
    # add a callback so we can count down to 0 and call the passed in callback
    numCallbacks = @clouds.length
    localCallback = () =>
      if --numCallbacks == 0
        if typeof callback == 'function'
          callback()

    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      transition = _.extend({}, css)

      if hideWhenDone
        hideTransition =
          display: 'none'
          complete: localCallback
      else
        # add a callback so we can count down to 0 and call the passed in callback
        transition.complete = localCallback

      cloud.animateCSS(transition, hideTransition)
    )

  applyCSSToLayers: (animate, css) =>
    _.each(@clouds, (cloud, index) =>
      # copy object first, transition will remove duration and delay so second cloud will not have those
      cssCopy = _.extend({}, css)

      cloud.applyCSSToLayers(animate, cssCopy)
    )

  transitionDown: () =>
    @stopAnimationLoop = true  # must stop the requestAnimationFrame loop otherwise it cancels out this transition

    @world.transition(
      transform: 'translateY(2000px)'
      duration: 600
      complete: =>
        AmoebaSite.presentation.setBackground('black')
    )

  hyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      duration: 2600
      complete: =>
        AmoebaSite.presentation.setBackground('white')

    )

  reversehyperspace: () =>
    t = "translateZ(#{@translateZ+2000}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.css(
      transform: t
      duration: 2600
    )
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      duration: 2600
      complete: =>
        AmoebaSite.presentation.setBackground('blue')
    )

  zoomWorld: () =>
    @translateZ = -4000
    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.css(
      transform: t
      opacity: 0.1
    )
    @translateZ = 2000

    t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
    @world.transition(
      transform: t
      opacity: 1
      delay: 400
      duration: 2600
    )

  _animateLayer: () =>
    if @stopAnimationLoop
      return

    # call this first
    requestAnimationFrame(this._animate);

    if @automaticallyRotateWorld
      this.updateWorld(@worldXAngle, @worldYAngle+0.15, @translateZ)

    if @translateWorld
      @translateWorld = false
      t = "translateZ(#{@translateZ}px) rotateX(#{@worldXAngle}deg) rotateY(#{@worldYAngle}deg)"
      @world.css(transform: t)

    _.each(@clouds, (cloud, index) =>
      # could add this later
      # cloud.style.webkitFilter = 'blur(5px)';
      cloud.transformLayers(@worldXAngle, @worldYAngle)
    )

  # called by requestAnimationFrame to set the next state of animation
  _animate: () =>
    if @fps >= 60
      this._animateLayer()
    else
      setTimeout(() =>
        this._animateLayer()
      ,1000 / @fps)

  toggleRotateWorld: () =>
    @automaticallyRotateWorld = !@automaticallyRotateWorld
