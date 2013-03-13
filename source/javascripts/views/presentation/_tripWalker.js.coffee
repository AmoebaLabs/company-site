
class AmoebaSite.TripWalker
  constructor: (@parentDiv, @$masterDiv) ->
    @container = $('<div/>')
      .addClass('slide3DContainer')
      .appendTo(@parentDiv)

  run: () =>
    x = (@container.width() - @$masterDiv.width()) / 2
    y = (@container.height() - @$masterDiv.height()) / 2

    offset = 200
    this.zoomIn(x, y, true)
    this.zoomIn(x-offset, y-offset)
    this.zoomIn(x+offset, y+offset)
    this.zoomIn(x-offset, y+offset)
    this.zoomIn(x+offset, y-offset)

  zoomIn: (x, y, rotate=false) =>
    numSteps = 25

    r = 0
    rOffset = 0
    if rotate
      rOffset = 360/numSteps

    depth = 4000
    z = -depth
    zOffset = depth/numSteps

    _.each([0..numSteps], (loopIndex) =>
      clone = @$masterDiv.clone()
      clone.appendTo(@container)

      t = "translateX(#{x}px) translateY(#{y}px) translateZ(#{z}px) rotate(#{r}deg)"

      clone.css(
        scale: 1
        left: 0
        top: 0
        transform: t
        opacity: 0
      )

      do (clone) ->

        clone.transition(
          opacity:.8
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
