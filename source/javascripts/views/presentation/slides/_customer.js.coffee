
class AmoebaSite.Presentation.Slide_Customer extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("customerSlide")
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

    @imageSize = 200

    this._createDivs()

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      @message1.css(opacity: 0)
      @message2.css(opacity: 0)
      @message3.css(opacity: 0)

      @manImage1.css(opacity: 0)
      @manImage2.css(opacity: 0)
      @manImage3.css(opacity: 0)

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
          this._step2()
        when 2
          this._step3()
        when 3
          scheduleNextStep = false
          this._sideIsDone()

      if scheduleNextStep
        this._doNextStep(stepIndex + 1)

    , 1500)

  _sideIsDone: () =>
    console.log 'fuck it'
    this._typewriterEffect()

  _step1: () =>
    lame = false

    if lame
      @message1.css(
        opacity: 1
      )
      @message1.keyframe('bounceInDown', 1000, 'ease-out', 0, 1, 'normal', () =>
        @message1.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
      )

      # man image zoom in
      @manImage1.css(
        scale: 4
      )

      # do the transition
      @manImage1.transition(
        scale: 1
        opacity: 1
        duration: 1000
      )
    else
      this._tripWalker()

  _tripWalker: () =>
    @tripWalker.run()

  _step2: () =>
    return

    # hide previous divs
    this._hideDivs([@message1, @manImage1])

    # show new divs
    @message2.css(
      opacity: 1
    )
    @message2.keyframe('bounceInDown', 1000, 'ease-out', 0, 1, 'normal', () =>
      @message1.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

    # man image zoom in
    @manImage2.css(
      scale: 4
    )

    # do the transition
    @manImage2.transition(
      scale: 1
      opacity: 1
      duration: 1000
    )

  _step3: () =>
    return

    # hide previous divs
    this._hideDivs([@message2, @manImage2])

    # show new divs
    @message3.css(
      opacity: 1
    )
    @message3.keyframe('bounceInDown', 1000, 'ease-out', 0, 1, 'normal', () =>
      @message1.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

    # man image zoom in
    @manImage3.css(
      scale: 4
    )

    # do the transition
    @manImage3.transition(
      scale: 1
      opacity: 1
      duration: 1000
    )

  _hideDivs: (divsArray) =>
    _.each(divsArray, (element) =>
      element.transition(
        opacity: 0
        duration: 300
      )
    )

  _createDivs: () =>
    messageString1 = 'Who are you?'
    messageString2 = 'Our ideal customer is funded, has a strong vision, but haven’t yet built out their app (or maybe only have a prototype).'
    messageString3 = 'We work with you to build on your idea until a viable product emerges through our lean, iterative approach.'

    @message1 = $('<div/>')
      .text(messageString1)
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "4em"
        position: "absolute"
        textAlign: "center"
        top: 0
        left: 0
        opacity: 0
        width: "100%"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )
    @message2 = $('<div/>')
      .text(messageString2)
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "2em"
        position: "absolute"
        textAlign: "center"
        top: 0
        left: 0
        opacity: 0
        width: "100%"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )
    @message3 = $('<div/>')
      .text(messageString3)
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "2em"
        position: "absolute"
        textAlign: "center"
        top: 0
        left: 0
        opacity: 0
        width: "100%"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )

    @manImage1 = this._createImageDiv('/images/presentation/man.svg')
    @manImage2 = this._createImageDiv('/images/presentation/man_question.svg')
    @manImage3 = this._createImageDiv('/images/presentation/man_exclaim.svg')

    @tripWalker = new AmoebaSite.TripWalker(@el, @manImage1)

  _createImageDiv: (path) =>
    result = $('<div/>')
      .appendTo(@el)
      .css(
        backgroundImage: 'url("' + path + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'

        top: (@el.height() - @imageSize) / 2
        left: (@el.width() - @imageSize) / 2
        position: "absolute"
        width: @imageSize
        height: @imageSize
        opacity: 0
      )

    return result

  _typewriterEffect: () =>
    container = $('<div/>')
      .appendTo(@el)
      .css(
        position: "absolute"
        bottom: 0
        left: 0
        width: 0
        height: 200
        overflow: 'hidden'
      )
    message = $('<div/>')
      .text("Designed by Richard Enlow (aka Klaay Kumjore)")
      .appendTo(container)
      .attr(class: "amoebaText")
      .css(
        fontSize: "1em"
        position: "absolute"
        textAlign: "center"
        top: 0
        left: 0
        width: @el.width()
        textShadow: "pink 0px 0px 4px"
        color: "#{AmoebaSite.Colors.amoebaGreenDark}"
      )

    container.transition(
      width: '100%'
      duration: 8000
    )
