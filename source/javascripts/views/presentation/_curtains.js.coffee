
class AmoebaSite.Curtains
  constructor: (@parentDiv, @closeCurtains, @callback) ->
    @container = $('<div/>')
#      .addClass('slide3DContainer')
      .css(
        height: '100%'
        width: '100%'
        overflow: 'hidden'
        zIndex: 1000
      )
      .appendTo(@parentDiv)

    this._start()

  tearDown: () =>
    if @container?
      @container.remove()
      @container = undefined

  _start: () =>
    leftStart = "-100%"
    leftEnd = "-50%"

    rightStart = "100%"
    rightEnd = "50%"

    # if closing, swap the values
    if @closeCurtains
      [leftStart, leftEnd] = [leftEnd, leftStart]
      [rightStart, rightEnd] = [rightEnd, rightStart]

    left = this._createCurtainDiv(leftStart, "skew(-10deg)")
    right = this._createCurtainDiv(rightStart, "skew(10deg)")

    left.transition(
      left: leftEnd
      easing: 'ease'
      transform: "skew(0deg)"

      duration: 2000

      complete: =>
        # remove shadow, looks ugly when they both touch
        left.css(
          boxShadow: "0px 0px 0px rgba(0, 0, 0, 1.0)"
        )
    )
    right.transition(
      left: rightEnd
      easing: 'ease'
      transform: "skew(0deg)"

      duration: 2000
      complete: =>
        # remove shadow, looks ugly when they both touch
        right.css(
          boxShadow: "0px 0px 0px rgba(0, 0, 0, 1.0)"
        )

        # pause when closed
        setTimeout( =>
          this.callback?()
        , 1000)
    )

  _createCurtainDiv: (left, transform) =>
    result = $('<div/>')
      .css(
        position: "absolute"
        top: 0
        left: left
        width: "100%"
        height: "100%"
        opacity: 1
        transform: transform
        backgroundColor: AmoebaSite.Colors.amoebaGreenMedium
        boxShadow: "0px 0px 50px rgba(0, 0, 0, 1.0)"
        border: "solid 1px black"
      )
      .appendTo(@container)

    return result
