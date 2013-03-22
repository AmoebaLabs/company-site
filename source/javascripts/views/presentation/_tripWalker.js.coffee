
class AmoebaSite.TripWalker
  constructor: (@parentDiv, @imagePath, @callback) ->
    @numSteps = 25
    @imageSize = 200
    @zoomDepth = 4000

    @container = $('<div/>')
      .addClass('slide3DContainer')
      .appendTo(@parentDiv)

  run: () =>
    this._doFlyIn()
    this._callCallback()

  tearDown: () =>
    if @container
      @container.remove()
      @container = undefined

  _createImageDiv: (path) =>
    result = $('<div/>')
      .css(
        backgroundImage: 'url("' + path + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'

        top: (@container.height() - @imageSize) / 2
        left: (@container.width() - @imageSize) / 2
        position: "absolute"
        width:@imageSize
        height: @imageSize
        opacity: 0
      )

  _doZoomIn: () =>
    # make sure we haven't been torn down already
    if not @container?
      return

    @steps = 0
    @container.empty()

    masterDiv = this._createImageDiv(@imagePath)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._zoomIn(masterDiv, x, y)
    this._zoomIn(masterDiv, x-offset, y-offset)
    this._zoomIn(masterDiv, x+offset, y+offset)
    this._zoomIn(masterDiv, x-offset, y+offset)
    this._zoomIn(masterDiv, x+offset, y-offset)

  _zoomIn: (masterDiv, x, y, rotate=false) =>
    r = 0
    rOffset = 0
    if rotate
      rOffset = 360/@numSteps

    z = -@zoomDepth
    zOffset = @zoomDepth/@numSteps

    @steps += @numSteps+1

    _.each([0..@numSteps], (loopIndex) =>
      last = loopIndex == @numSteps

      clone = masterDiv.clone()
      clone.appendTo(@container)

      t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px) rotate(#{r}deg)"

      clone.css(
        scale: 1
        left: 0
        top: 0
        transform: t
        opacity: 0
      )

      clone.transition(
        opacity:1
        delay: loopIndex * 30
        duration: 1
        complete: =>
          if !last
            clone.transition(
              opacity: 0
              delay: 0
              duration: 800
              complete: =>
                clone.remove()    # remove ourselves

                this._afterZoomInStep()
            )
          else
            this._afterZoomInStep()
      )

      z += zOffset
      r += rOffset
    )

  _doFlyIn: () =>
    # make sure we haven't been torn down already
    if not @container?
      return

    # counter so we know when we are all done
    @steps = 0
    @container.empty()

    masterDiv = this._createImageDiv(@imagePath)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._flyIn(masterDiv, x, y, false, true)
    this._flyIn(masterDiv, x, y, true, true)
    this._flyIn(masterDiv, x-offset, y-offset, false)
    this._flyIn(masterDiv, x+offset, y+offset, true)
    this._flyIn(masterDiv, x-offset, y+offset, false)
    this._flyIn(masterDiv, x+offset, y-offset, true)

  _flyIn: (masterDiv, x, y, fromRight, rotate=false) =>
    rOffset = 0
    if rotate
      rOffset = 360/(@numSteps-1)
      if fromRight
        rOffset *= -1

    r = 0

    len = (x + @imageSize)
    xOff = x - len

    if fromRight
      len = @container.width() - x
      xOff = x + len

    xOffset = len/(@numSteps-1)

    if fromRight
      xOffset *= -1

    last = false

    @steps += @numSteps

    _.each([0...@numSteps], (loopIndex) =>
      last = loopIndex == (@numSteps - 1)

      clone = masterDiv.clone()
      clone.appendTo(@container)

      t = "translateX(#{xOff}px) translateY(#{y}px) rotate(#{r}deg)"

      clone.css(
        scale: 1
        left: 0
        top: 0
        transform: t
        opacity: 0
      )

      do (last) =>
        clone.transition(
          opacity:1
          delay: loopIndex * 70
          duration: 0
          complete: =>
            if !last
              clone.transition(
                opacity: 0
                delay: 0
                duration: 800
                complete: =>
                  clone.remove()    # remove ourselves

                  this._afterFlyInStep()
              )
            else
              this._afterFlyInStep()
        )

      xOff += xOffset
      r += rOffset
    )

  _doBackIn: () =>
    # make sure we haven't been torn down already
    if not @container?
      return

    @steps = 0
    @container.empty()

    masterDiv = this._createImageDiv(@imagePath)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._backIn(masterDiv, x, y)
    this._backIn(masterDiv, x-offset, y-offset)
    this._backIn(masterDiv, x+offset, y+offset)
    this._backIn(masterDiv, x-offset, y+offset)
    this._backIn(masterDiv, x+offset, y-offset)

  _backIn: (masterDiv, x, y) =>
    clone = masterDiv.clone()
    clone.appendTo(@container)

    @steps++

    clone.css(
      x:x
      y:y
      left: 0
      top: 0
      opacity: 1
      transformOrigin: 'left 50% 0'
    )

    t = "translateX(#{x}px) translateY(#{y}px) rotateY(45deg)"
    clone.transition(
      transform: t
      transformOrigin: 'left 50% 0'

      delay: Math.random() * 500
      duration: 800
      complete: =>
        t = "translateX(#{x}px) translateY(#{y}px) rotateY(0deg)"
        clone.transition(
          transform: t
          transformOrigin: 'left 50% 0'
          duration: 800
          complete: =>
            t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{-@zoomDepth}px))"
            clone.transition(
              transform: t
              duration: 800
              complete: =>
                this._afterBackInStep()
            )
        )
    )

  _doBowDown: () =>
    # make sure we haven't been torn down already
    if not @container?
      return

    @steps = 0
    @container.empty()

    masterDiv = this._createImageDiv(@imagePath)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._bowDown(masterDiv, x, y)
    this._bowDown(masterDiv, x-offset, y-offset)
    this._bowDown(masterDiv, x+offset, y+offset)
    this._bowDown(masterDiv, x-offset, y+offset)
    this._bowDown(masterDiv, x+offset, y-offset)

  _bowDown: (masterDiv, x, y) =>
    clone = masterDiv.clone()
    clone.appendTo(@container)

    @steps++

    clone.css(
      x:x
      y:y
      left: 0
      top: 0
      opacity: 1
      transformOrigin: '50% bottom 0'
    )

    t = "translateX(#{x}px) translateY(#{y}px) rotateX(-45deg)"
    clone.transition(
      transform: t
      transformOrigin: '50% bottom 0'
      delay: Math.random() * 500
      duration: 800
      complete: =>
        t2 = "translateX(#{x}px) translateY(#{y}px) rotateX(0deg)"
        clone.transition(
          transform: t2
          transformOrigin: '50% bottom 0'
          duration: 800
          complete: =>
            this._afterBowDownStep()
        )
    )

  _afterFlyInStep: () =>
    if --@steps == 0
      this._doBackIn()
      this._callCallback()

  _afterBackInStep: () =>
    if --@steps == 0
      this._doZoomIn()
      this._callCallback()

  _afterZoomInStep: () =>
    if --@steps == 0
      this._doBowDown()
      this._callCallback()

  _afterBowDownStep: () =>
    if --@steps == 0
      this._callCallback(true)

  _callCallback: (done=false) =>
   if @callback
        @callback(done)
