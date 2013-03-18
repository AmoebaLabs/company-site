
class AmoebaSite.Presentation.Slide_Intro extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("introSlide")
    @transition = 'zoom'

    dark = true
    @titleColor = 'rgba(255,255,255,.4)'
    @amoebaTitleAnimation = 'amoebaTitlePulse'
    @amoebaInfoAnimation = 'amoebaInfoPulse'
    @spaceToContinueMessage = 'Press the space bar to continue'
    if dark
      @amoebaTitleAnimation = 'amoebaTitlePulseDark'
      @titleColor = 'rgba(0,0,0,.4)'
      @amoebaInfoAnimation = 'amoebaInfoPulseDark'

    @title = $('<div/>')
      .html('Amoeba<sup style="vertical-align: super; font-size: 0.2em;">\u2120</sup>')   # vertical-align: super is the magic that makes this work
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "16em"
        position: "absolute"
        textAlign: "center"
        top: 120
        left: 0
        width: "100%"
        color: @titleColor
        opacity: 0
      )

    @instructions = $('<div/>')
      .text(@spaceToContinueMessage)
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "2em"
        position: "absolute"
        textAlign: "center"
        top: 480
        left: 0
        width: "100%"
        color: AmoebaSite.Colors.amoebaGreenDark
        opacity: 0
      )

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      # delay a bit and then show stuff
      setTimeout =>
        this._showTitle()
      , 500

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # clear the animation running infinitely
      @title.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

      # set back to opacity:0 to reset the state for the back button
      @title.css(opacity: 0)
      @instructions.css(opacity: 0)

  _showTitle: () =>
    @title.css(
      opacity: 1
    )

    @title.keyframe('fadeInUp', 1800, 'ease-out', 0, 1, 'normal', () =>
      @title.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

      @title.keyframe(@amoebaTitleAnimation, 2800, 'ease-out', 0, 'infinite', 'alternate', () =>
        @title.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
      )

      this._showInstructions()
    )

  _showInstructions: () =>
    @instructions.css(
      opacity: 1
    )

    @instructions.keyframe('fadeInUpBig', 1800, 'ease-out', 0, 1, 'normal', () =>
      @instructions.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

      # slideDone autoadvance to next slide after delay
      this._slideIsDone(1000)

      @instructions.keyframe(@amoebaInfoAnimation, 1800, 'ease-in-out', 0, 'infinite', 'normal', () =>
        @instructions.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
      )
    )
