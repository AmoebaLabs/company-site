
class AmoebaSite.HomeScene
  constructor: (@el) ->
    AmoebaSite.presentation.setBackground('black')
    this._createMascot()
    this._createStarsAndPlanet()

  tearDown: =>
    @cube?.tearDown()
    @cube = undefined

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

  _createStarsAndPlanet: () =>
    @$planet = $("<img/>")
      .attr(src: "/images/presentation/planet.svg")
      .css(
        position: 'absolute'
        height: 2000
        width: 2000
        top: '40%'
        left: -400
        opacity: 1
        zIndex: -1
      )
      .appendTo(@el)

  _hideHomeDivs: (show) =>
    @mascot.css(
      display: if show == true then 'block' else 'none'
    )
    @$planet.css(
      display: if show == true then 'block' else 'none'
    )

  _zoomInOnMascotEyes: =>
    # scale and translate x,y to zoom into eyes
    @el.transition(
      opacity:1
      scale: 25
      x: 7000
      y: 1100
      duration: 2000
      complete: =>
        this._hideHomeDivs()
        AmoebaSite.presentation.setBackgroundColor(AmoebaSite.Colors.amoebaGreenMedium)

        @el.css(
          scale: 1
          x: 0
          y: 0
        )
        this._fadeInCube()
    )

  _fadeInCube: () =>
    @cube = new AmoebaSite.CubeScene(@el, this._cubeCallback)

  _cubeCallback: () =>
    sentence = "As the client hires developers, we include them on our team, at our offices. As integrated team members, our client's develop- ers are trained on the processes, tools and technologies they will need to continue development after version 1.0 and beyond."

    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Preparing You", theCSS, 'message', @el)
    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, 'message', @el)

    title.css(
      top:70
      left: '50%'
    )
    title.transition(
      opacity: 1
      duration: 800
    )

    message.css(
      top:450
      left: '50%'
      width: 450
    )
    message.transition(
      opacity: 1
      duration: 800
      complete: =>
        this._slideIsDone(1000)
    )







