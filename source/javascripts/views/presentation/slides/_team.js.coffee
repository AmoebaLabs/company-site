
class AmoebaSite.Presentation.Slide_Team extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("teamSlide")
    @transition = 'zoom'

    @button = $('<button/>')
      .text('Again')
      .appendTo(@el)
      .css(
        position: 'absolute'
        bottom: 20
        right: 20
        width: 100
        zIndex: 400
      )
      .click( (event) =>
        this._tripWalker()
      )

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      if @tripWalker
        @tripWalker.tearDown()
        @tripWalker = undefined

      if @typewriter
        @typewriter.tearDown()
        @typewriter = undefined

  _start: () =>
    this._doNextStep(0)

  _doNextStep: (stepIndex) =>
    # can't use the keyframe animation delay parameter since that will draw the text at the current
    # position while it's waiting to start
    scheduleNextStep = true

    setTimeout( =>

      switch stepIndex
        when 0
          this._step1()
        when 1
          scheduleNextStep = false
          this._typewriterEffect("We are here to help.", 0)

      if scheduleNextStep
        this._doNextStep(stepIndex + 1)

    , 1500)

  _step1: () =>
    this._tripWalker()

  _tripWalkerCallback: () =>
    this._slideIsDone(1000)

  _tripWalker: () =>
    if not @tripWalker?
      @tripWalker = new AmoebaSite.TripWalker(@el, '/images/presentation/man.svg', this._tripWalkerCallback)

    @tripWalker.run()

  _typewriterEffect: (message, bottom) =>
    if not @typewriter?
      css =
        bottom: bottom
        height: 200
        width: 400

      @typewriter = new AmoebaSite.Typewriter(@el, message, css)

    @typewriter.write()
