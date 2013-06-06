
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

    left = this._createCurtainDiv(leftStart)
    right = this._createCurtainDiv(rightStart)

    left.transition(
      left: leftEnd
      duration: 2000
    )
    right.transition(
      left: rightEnd
      duration: 2000
      complete: =>
        console.log 'callback'
        this.callback?()
    )

  _createCurtainDiv: (left) =>
    result = $('<div/>')
      .css(
        position: "absolute"
        top: 0
        left: left
        width: "100%"
        height: "100%"
        opacity: 1
        backgroundColor: 'green'
      )
      .appendTo(@container)

    return result
