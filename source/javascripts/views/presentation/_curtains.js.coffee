
class AmoebaSite.Curtains
  constructor: (@parentDiv, @closeCurtains, @callback) ->
    @faderMaxOpacity = .5

    this._createContainer()
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

    @fader.transition(
      opacity: if @closeCurtains then 0 else @faderMaxOpacity
      duration: 2000
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
    this.callback?()

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
        zIndex: 1002
      )
      .appendTo(@container)

    return result

  _createCurtains: =>
    @leftStart = "-110%"
    @leftEnd = "-50%"
    @leftSkew = "skew(-10deg)"

    @rightStart = "110%"
    @rightEnd = "50%"
    @rightSkew = "skew(10deg)"

    # if closing, swap the values
    if @closeCurtains
      [@leftStart, @leftEnd] = [@leftEnd, @leftStart]
      [@rightStart, @rightEnd] = [@rightEnd, @rightStart]
      [@leftSkew, @rightSkew] = [@rightSkew, @leftSkew]

    @left = this._createCurtainDiv(@leftStart, @leftSkew)
    @right = this._createCurtainDiv(@rightStart, @rightSkew)

  _createContainer: =>
    @container = $('<div/>')
      .css(
        position: 'absolute'
        top: 0
        left: 0
        height: '100%'
        width: '100%'
        overflow: 'hidden'
        zIndex: 1000
      )
      .appendTo(@parentDiv)

    @fader = $('<div/>')
      .css(
        position: 'absolute'
        top: 0
        left: 0
        height: '100%'
        width: '100%'
        zIndex: 1001

        opacity: if @closeCurtains then @faderMaxOpacity else 0
        backgroundColor: 'black'
      )
      .appendTo(@container)
