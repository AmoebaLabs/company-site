
class AmoebaSite.Presentation.Slide_Home extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("homeSlide")
    @transition = 'zoom'

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    # tear down stuff

  _start: =>
    AmoebaSite.presentation.setBackground('black')
    this._createMascot()
    this._createStarsAndPlanet()

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


  _zoomInOnMascotEyes: =>
    # scale and translate x,y to zoom into eyes
    @el.transition(
      opacity:1
      scale: 12
      x: 3400
      y: 0
      duration: 3000
    )


