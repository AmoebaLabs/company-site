
class AmoebaSite.Presentation.Slide_Computer extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("computerSlide")
    @transition = 'zoom'
    this._createDivs()
    @mascot = new AmoebaSite.MascotController

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

      # make sure mascot comes back if entering presenation and is removed in other cases
      @mascot.slideIn()

  slideOut: (afterTransitionComplete) =>
    if !afterTransitionComplete
      @mascot.zoomOut()
    else
      # reset stuff back to invisible
      @message.css(
        opacity: 0
      )
      @imgEl.css(
        opacity: 0
      )

  _start: () =>
    # starting point
    @imgEl.css(
      scale: 4
    )

    # do the transition
    @imgEl.transition(
      scale: 1
      opacity: 1
      duration: 1000
    )

    # can't use the keyframe animation delay parameter since that will draw the text at the current
    # position while it's waiting to start
    setTimeout( =>
      @message.css(
        opacity: 1
      )
      @message.keyframe('bounceInDown', 1000, 'ease-out', 0, 1, 'normal', () =>
        @message.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

        this._slideIsDone(1000)
      )
    , 400)

  _createDivs: () =>
    @message = $('<div/>')
      .text("We design and build web apps...")
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

    @imgEl = $('<img/>')
      .appendTo(@el)
      .attr(
        src: '/images/presentation/computer.svg'
      )
      .css(
        bottom: 0
        left: 0
        position: "absolute"
        width: "100%"
        height: "80%"
        opacity: 0
      )
