
class AmoebaSite.Presentation.Slide_Phone extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("phoneSlide")
    @transition = 'rotate'
    this._createDivs()
    @currentAnimationIndex = 0

  slideIn: (afterTransitionComplete) =>
    # make sure mascot comes back if entering presenation and is removed in other cases
    if !afterTransitionComplete
      this._stepZero()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      @message.css(opacity: 0)
      @message2.css(opacity: 0)
      @finalMessage.css(opacity: 0)

      # reset the animation count
      @currentAnimationIndex = 0

  _createDivs: () =>
    # loading image first so we can get the width and height
    # note: the card will be display: none when this is called, so other methods will fail
    @imgEl = $('<img/>')
      .css(
        position: 'absolute'
      )
      .attr(src: '/images/presentation/mobile.svg')
      .appendTo(@el)

    # create text that slides down
    @banner = $('<div/>')
      .text("and mobile apps.")
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        fontSize: "3em"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
        opacity: 0
      )

    theTop = 210
    theTop2 = 290

    # create text that slides down
    @message = $('<div/>')
      .text("We're")
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        opacity: 0
        left: 0
        top: theTop
        fontSize: "7em"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )
    @message2 = $('<div/>')
      .text("Agile")
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        opacity: 0
        left: 0
        top: theTop2
        fontSize: "13em"
        textTransform: "uppercase"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenMedium} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreen}"
      )

    @finalMessage = $('<div/>')
      .text("...and that's more than a buzz word. To us, it’s a pervasive philosophy.")
      .appendTo(@el)
      .attr(class: "amoebaText")
      .css(
        opacity: 0
        left: 0
        top: 520
        fontSize: "3em"
        textTransform: "uppercase"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )

  _setNextAnimationTimer: =>
    @currentAnimationIndex++

    setTimeout( =>
      switch @currentAnimationIndex
        when 0
          this._stepZero();
        when 1
          this._stepOne();
        when 2
          this._stepTwo();
        when 3
          this._stepThree();
        else
          console.log("wtf?")
    , 1500)

  _stepZero: () =>
    newHeight = 350
    newWidth = @el.width()

    @imgEl.css(
      opacity: 1
      rotate: 0
      left: 0
      top: 100
      height: newHeight
      width: newWidth
    )
    @banner.transition(
      opacity: 1
      duration: 800
    )

    this._setNextAnimationTimer()

  _stepOne: () =>
    newHeight = @el.width()
    newWidth = @el.width()

    @imgEl.transition(
      opacity: 1
      rotate: -90
      left: (newHeight - newWidth) / 2
      top: -100
      height: newHeight
      width: newWidth
      duration: 400
    )
    .transition(  # could not use a standard keyframe animation since rotation would be reverted.
      scale: 1.1
      duration: 100
    )
    .transition(
      scale: 1
      duration: 200
    )
    this._setNextAnimationTimer()

  _stepTwo: () =>
    @message.css(
      opacity: 1
    )
    @message2.css(
      opacity: 1
    )

    @message.keyframe('bounceInDown', 800, 'ease-out', 0, 1, 'normal', () =>
      @message.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )
    @message2.keyframe('bounceInDown', 800, 'ease-out', 0, 1, 'normal', () =>
      @message2.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

    @banner.transition(
      opacity: 0
      duration: 800
    )
    this._setNextAnimationTimer()

  _stepThree:() =>
    @finalMessage.css(
      opacity: 1
    )

    @finalMessage.keyframe('fadeInUp', 800, 'ease-out', 0, 1, 'normal', () =>
      @finalMessage.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

    @imgEl.transition(
      opacity: 0
      duration: 800
    )
