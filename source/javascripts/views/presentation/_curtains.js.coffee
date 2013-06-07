
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

    this._createCurtains()
    this._step1()

  tearDown: () =>
    if @container?
      @container.remove()
      @container = undefined

  _step1: () =>
    @left.transition(
      left: @leftEnd
      easing: 'ease'
      transform: "skew(0deg)"

      duration: 2000
    )
    @right.transition(
      left: @rightEnd
      easing: 'ease'
      transform: "skew(0deg)"

      duration: 2000
      complete: =>
        this._step2()
    )

  _step2: =>
    # fade out border and shadow, looks ugly when they both touch
    @left.transition(
      boxShadow: "0px 0px 0px rgba(0, 0, 0, 0)"
      border: "solid 1px transparent"
      duration: 1000
    )

    @right.transition(
      boxShadow: "0px 0px 0px rgba(0, 0, 0, 0)"
      border: "solid 1px transparent"
      duration: 1000

      complete: =>
        this._step3()
    )

  _step3: =>
    # pause before callback
    setTimeout( =>
      this.callback?()
    , 2000)

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
        border: "solid 1px transparent"
      )
      .appendTo(@container)

    return result

  _createCurtains: =>
    @leftStart = "-100%"
    @leftEnd = "-50%"

    @rightStart = "100%"
    @rightEnd = "50%"

    # if closing, swap the values
    if @closeCurtains
      [@leftStart, @leftEnd] = [@leftEnd, @leftStart]
      [@rightStart, @rightEnd] = [@rightEnd, @rightStart]

    @left = this._createCurtainDiv(@leftStart, "skew(-10deg)")
    @right = this._createCurtainDiv(@rightStart, "skew(10deg)")
