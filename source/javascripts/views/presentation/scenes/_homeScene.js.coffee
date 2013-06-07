
class AmoebaSite.HomeScene
  constructor: (@el, @callback) ->
    AmoebaSite.presentation.setBackground('black')
    this._createMascot()

  tearDown: =>
    @cube?.tearDown()
    @cube = undefined

    @toolsScene?.tearDown()
    @toolsScene = undefined

    @cloudScene?.tearDown()
    @cloudScene = undefined

  _createMascot: =>
    @mascot = $('<img/>')
      .attr(src: '/images/presentation/mascot_noshadow.svg')
      .appendTo(@el)
      .click( (e) =>
        this._zoomInOnMascotEyes()
      )
      .css(
        position: 'absolute'
        top: 250
        height: 360
        width: 360
        opacity: 1
      )

  _hideDiv: (theDiv, show) =>
    @mascot.css(
      display: if show == true then 'block' else 'none'
    )
  _zoomInOnMascotEyes: =>
    # scale and translate x,y to zoom into eyes
    @el.transition(
      opacity:1
      scale: 10
      x: 320
      y: 10
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        this._hideDiv(@mascot)
        AmoebaSite.presentation.setBackgroundColor(AmoebaSite.Colors.amoebaGreenMedium)

        @el.css(
          scale: 1
          x: 0
          y: 0
        )
        this._runSequence()
    )

  _runSequence: () =>
    @cube = new AmoebaSite.CubeScene(@el, =>
      @cube.tearDown()
      @cube = undefined

      @toolsScene = new AmoebaSite.ToolsScene(@el, =>
        @toolsScene.tearDown()
        @toolsScene = undefined

        @cloudScene = new AmoebaSite.CloudScene(@el, =>
          # keep the clouds on for a few seconds
          setTimeout(=>
            this.sequenceDone()
          , 2000)
        )
      )

      @toolsScene.start()
    )

  sequenceDone: =>
    # old shit, throw away if not used
    #          @cloudScene.tearDown()
    #          @cloudScene = undefined
    #          AmoebaSite.presentation.setBackground('black')
    #          this._hideDiv(@mascot, true)

    # we're done, call the callback
    this.callback?()

