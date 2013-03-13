
class AmoebaSite.TripWalker
  constructor: (@parentDiv, @imagePath) ->
    @numSteps = 25
    @imageSize = 200

    @container = $('<div/>')
      .addClass('slide3DContainer')
      .appendTo(@parentDiv)

  run: () =>
    @container.empty()
    this._doFlyIn()
    # this._doZoomIn()

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
    masterDiv = this._createImageDiv(@imagePath)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._zoomIn(masterDiv, x, y, true)
    this._zoomIn(masterDiv, x-offset, y-offset)
    this._zoomIn(masterDiv, x+offset, y+offset)
    this._zoomIn(masterDiv, x-offset, y+offset)
    this._zoomIn(masterDiv, x+offset, y-offset)

  _zoomIn: (masterDiv, x, y, rotate=false) =>
    r = 0
    rOffset = 0
    if rotate
      rOffset = 360/@numSteps

    depth = 4000
    z = -depth
    zOffset = depth/@numSteps

    _.each([0...@numSteps], (loopIndex) =>
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
          clone.transition(
            opacity: 0
            delay: 0
            duration: 800
            complete: =>
              clone.remove()    # remove ourselves
          )
      )

      z += zOffset
      r += rOffset
    )


  _doFlyIn: () =>
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

    if fromRight
      xOff = x + len
    else
      xOff = x - len

    xOffset = len/(@numSteps-1)

    if fromRight
      xOffset *= -1

    last = false

    _.each([0...@numSteps], (loopIndex) =>
      last = loopIndex == (@numSteps - 1)

      if last
        console.log "#{loopIndex}"

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
              )
            else
              console.log 'last'
        )

      xOff += xOffset
      r += rOffset
    )
