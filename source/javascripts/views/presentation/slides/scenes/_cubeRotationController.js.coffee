
class AmoebaSite.CubeRotationController
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
      duration: AmoebaSite.utils.dur(duration)
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
        , AmoebaSite.utils.dur(delay))

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

