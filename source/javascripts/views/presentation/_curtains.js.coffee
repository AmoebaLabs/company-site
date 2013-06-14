
class AmoebaSite.Curtains
  constructor: (@parentDiv, @openCurtains, @callback) ->
    this._initVariables()
    this._createContainer()
    this._createCurtains()

    this._step0()

  tearDown: =>
    if @container?
      @container.remove()
      @container = undefined

  _step0: =>
    this.callback?('0')

    # open curtains fades in curtains, closing just shows them immediately
    if @openCurtains
      @container.css(
        top: -@container.height()
      )

      @container.transition(
        easing: 'ease'
        top: 0
        opacity: 1
        duration: AmoebaSite.utils.dur(1000)
        complete: =>
          this._step1()
      )
    else
      @container.css(
        opacity: 1
      )
      this._step1()

  _step1: =>
    this.callback?('1')

    # timeout was added to give new view time to redraw itself before curtains opened.
    # worked fine when just swapping views out, but new code uses navigate() which seems slow.
    setTimeout(=>
      @left.transition(
        left: @leftEnd
        easing: 'ease'
        transform: @leftEndSkew

        duration: AmoebaSite.utils.dur(2000)
      )
      @right.transition(
        left: @rightEnd
        easing: 'ease'
        transform: @rightEndSkew

        duration: AmoebaSite.utils.dur(2000)
        complete: =>
          this._step2()
      )

      @fader.transition(
        opacity: @faderEndOpacity
        duration: AmoebaSite.utils.dur(2000)
      )
    , 500)

  _step2: =>
    this.callback?('2')

    # fade out border and shadow, looks ugly when they both touch
    @left.transition(
      boxShadow: "0px 0px 0px rgba(0, 0, 0, 0)"
      border: "solid 1px transparent"
      duration: AmoebaSite.utils.dur(1000)
    )

    @right.transition(
      boxShadow: "0px 0px 0px rgba(0, 0, 0, 0)"
      border: "solid 1px transparent"
      duration: AmoebaSite.utils.dur(1000)

      complete: =>
        this._step3()
    )

  _step3: =>
    this.callback?('done')

  _createCurtainDiv: (left, skew) =>
    result = $('<div/>')
      .css(
        position: "absolute"
        top: 0
        left: left
        width: "100%"
        height: "100%"
        opacity: 1
        transform: skew
        backgroundColor: AmoebaSite.Colors.amoebaGreenMedium
        boxShadow: "0px 0px 50px rgba(0, 0, 0, 1.0)"
        border: "solid 1px transparent"
        zIndex: 1002
      )
      .appendTo(@container)

    return result

  _createCurtains: =>
    @left = this._createCurtainDiv(@leftStart, @leftStartSkew)
    @right = this._createCurtainDiv(@rightStart, @rightStartSkew)

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

        opacity: 0  # start off transparent
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

        opacity: @faderStartOpacity
        backgroundColor: 'black'
      )
      .appendTo(@container)

  _initVariables: =>
    @faderStartOpacity = 0
    @faderEndOpacity = .6

    @leftStart = "-110%"
    @leftEnd = "-50%"
    @leftStartSkew = "skew(-10deg)"
    @leftEndSkew = "skew(0deg)"

    @rightStart = "110%"
    @rightEnd = "50%"
    @rightStartSkew = "skew(10deg)"
    @rightEndSkew = "skew(0deg)"

    # if closing, swap the values
    if @openCurtains
      [@leftStart, @leftEnd] = [@leftEnd, @leftStart]
      [@rightStart, @rightEnd] = [@rightEnd, @rightStart]
      [@leftStartSkew, @rightStartSkew] = [@rightStartSkew, @leftStartSkew]
      [@faderStartOpacity, @faderEndOpacity] = [@faderEndOpacity, @faderStartOpacity]

      [@leftEndSkew, @leftStartSkew] = [@leftStartSkew, @leftEndSkew]
      [@rightEndSkew, @rightStartSkew] = [@rightStartSkew, @rightEndSkew]
