
class AmoebaSite.Presentation.Slide_Tools extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("toolsSlide")
    @transition = 'warp'
    @animationIndex = 0
    @endLocationTop = 220
    @endLocationLeft = 154
    @toolTopOffset = 30
    @rotateTransformOrigin = '28% bottom 0'

    @$items = this._buildTools()

    @width = AmoebaSB.layout.slideWidth
    @height = AmoebaSB.layout.slideHeight
    @widthOfOne = (@width/2) / @$items.length

    this._positionTools()
    this._createTextDivs()
    this._createRocket()
    this._createMascot()

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      # delay a bit and then show stuff
      setTimeout =>
        this._showTools()
        this._showTitle()
        this._showInfo()
        this._showRocket()
        this._setNextAnimationTimer()
      , 100

  slideOut: (afterTransitionComplete) =>
    # cancel the animation timers if set to run
    if @animationTimeout?
      clearTimeout(@animationIndex)
      @animationTimeout = undefined

    @animationIndex = 0

    if afterTransitionComplete
      this._swingLidClosed(false) # close the lid if opened

      # reset so it can run again
      this._positionTools()

      @rocketContainer.css(opacity: 0)
      @titleText.css(opacity: 0)
      @infoText.css(opacity: 0)
      @mascot.css(opacity: 0)

  _positionTools: =>
    leftOffset = @width-@widthOfOne
    leftOffset -= 10

    _.each(@$items, (element, index) =>
      element.css(
        left: leftOffset
        top: @toolTopOffset
        width: @widthOfOne
        height: @widthOfOne
        opacity: 0
      )

      leftOffset -= @widthOfOne
    )

  _showTools: =>
    _.each(@$items, (element, index) =>
      delay = index*100

      # we can't use the keyframes delay since we have to set the opacity to 1 before animating
      # if we try to use the delay, the item draws while it's waiting to animate
      setTimeout( =>
        element.css(
          opacity: 1
        )
        element.keyframe('bounceInDown', 2200, 'ease-in', 0, 1, 'normal', () =>
          element.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
        )
      , delay)
    )

  _buildOneItem: (image, url) =>
    containerDiv = $('<div/>')
      .appendTo(@el)
      .addClass('toolImage')
      .css(
        cursor: 'pointer'
        opacity: 0
        position: 'absolute'
        transform: 'translateZ(40px)'     # needed for zIndex to work? not sure why
#        padding: 10
#        boxSizing: 'border-box'   # keep the padding from exanding the size of the div
#        backgroundColor: 'rgba(255,255,255,0.4)'
#        border: '1px solid rgba(0, 0, 0, .2)'
#        borderRadius: 10
#        boxShadow: '0 2px 12px rgba(0, 0, 0, .4)'
      )
      .click( (event) =>
        window.location.assign(url)
      )
    imageDiv = $('<div/>')
      .appendTo(containerDiv)
      .css(
        backgroundImage: 'url("' + image + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '100%'
        width: '100%'
      )

    return containerDiv

    @$items.push(containerDiv)

  _buildTools: () =>
    itemInfo = [
      {image: '/images/presentation/logo_ios.svg', url: 'http://apple.com'}
      {image: '/images/presentation/logo_html5.svg', url: 'http://html5rocks.com'}
      {image: '/images/presentation/logo_android.svg', url: 'http://android.com'}
      {image: '/images/presentation/logo_css3.svg', url: 'http://www.w3.org/Style/CSS/'}
      {image: '/images/presentation/logo_rails.svg', url: 'http://rubyonrails.org/'}
    ]

    result = []
    _.each(itemInfo, (element, index) =>
      result.push(this._buildOneItem(element.image, element.url))
    )

    return result

  _createTextDivs: () =>
    # create text that slides down
    @titleText = $('<div/>')
      .text("Jumpstart Startups")
      .appendTo(@el)
      .attr(class: "amoebaBoldFont")
      .css(
        fontSize: "4em"
        position: "absolute"
        textAlign: "right"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
        top: 200
        left: 0
        width: '100%'
        opacity: 0
      )

    info = "We partner with startups by combining software engineering, process and technology training. We staff projects with seasoned teams of developers experienced in Agile development philosophy...Tools ...and use a standard suite of open source technologies well-suited for a rapid roll- out. Training"

    @infoText = $('<div/>')
      .text(info)
      .appendTo(@el)
      .attr(class: "amoebaBoldFont")
      .css(
        fontSize: "1.4em"
        position: "absolute"
        textAlign: "left"
        textShadow: "#{AmoebaSite.Colors.amoebaGreen} 1px 0px 2px"
        color: "black"
        top: 300
        left: @width / 2
        width: @width / 2
        opacity: 0
      )

  _showTitle: () =>
    @titleText.css(
      opacity: 1
    )

    @titleText.keyframe('bounceInDown', 800, 'ease-out', 0, 1, 'normal', () =>
      @titleText.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

  _showInfo: () =>
    @infoText.css(
      opacity: 1
    )

    @infoText.keyframe('bounceInDown', 800, 'ease-out', 0, 1, 'normal', () =>
      @infoText.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

  _showRocket: () =>
    @rocketContainer.css(
      opacity: 1
    )

    @rocketContainer.keyframe('bounceInUp', 800, 'ease-out', 0, 1, 'normal', () =>
      @rocketContainer.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )

  _hideToolsAndMascot: =>
    @mascot.css(opacity: 0)
    _.each(@$items, (element, index) =>
      element.css(opacity: 0)
    )

  _blastOffRocket: () =>
    this._hideToolsAndMascot()

    @rocketContainer.css(
      opacity: 1
    )

    @rocketContainer.keyframe('bounceOutUp', 800, 'ease-out', 0, 1, 'normal', () =>
      @rocketContainer.css(
        opacity: 0
      )
      @rocketContainer.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')
    )
    this._setNextAnimationTimer()

  _createRocket: () =>
    @rocketContainer = $('<div/>')
      .appendTo(@el)
     .css(
        height: '100%'
        width: 400
        opacity: 0
      )

    @rocketLid = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_top_only.svg" + '")'
        backgroundPosition: 'center bottom'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'

        # without this, the first rotation is off a bit, not sure why
        transformOrigin: @rotateTransformOrigin

        height: '18%'
        width: '100%'
      )

    @rocket = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_body_only.svg" + '")'
        backgroundPosition: 'center top'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '58%'
        width: '100%'
        transform: 'translateZ(0px)'     # needed for zIndex to work? not sure why
      )

    @rocketFlame = $('<div/>')
      .appendTo(@rocketContainer)
      .css(
        backgroundImage: 'url("' + "/images/presentation/rocket_flame_only.svg" + '")'
        backgroundPosition: 'center top'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        height: '24%'
        width: '100%'
      )

  _swingLidOpen: =>
    @rocketLid.transition(
      transformOrigin: @rotateTransformOrigin
      transform: 'rotate(-125deg)'
    )
    this._setNextAnimationTimer()

  _swingLidClosed: (animate=true) =>
    if animate
      @rocketLid.transition(
        transformOrigin: @rotateTransformOrigin
        transform: 'rotate(0deg)'
      )

      this._setNextAnimationTimer()
    else
      # called on slideOut to reset things back to normal
      @rocketLid.css(
        transformOrigin: @rotateTransformOrigin
        transform: 'rotate(0deg)'
      )

  _setNextAnimationTimer: (delayTime = 1200) =>
    @animationTimeout = setTimeout( =>
      @animationTimeout = undefined

      # don't continue unless the active slide
      if @activeSlide
        switch @animationIndex
          when 0
            this._swingLidOpen()
          when 1
            this._droptToolsInRocket()
          when 2
            this._popoutMascot()
          when 3
            this._swingLidClosed()
          when 4
            this._blastOffRocket()
          else
            this._finalStep()

        @animationIndex++
    , delayTime)

  _finalStep: =>
    @animationIndex = -1
    this._slideIsDone(1000)

  _dropOneTool: (tools) =>
    element = tools.shift()

    element.css(
      opacity: 1
    )
    element.transition(
      top: @toolTopOffset / 4
      left: @endLocationLeft
      duration: 500
      easing: 'snap'
    )

    # bounce
    .transition(
      scale: 1.25
      duration: 100
    )
    .transition(
      scale: 0.9
      duration: 100
    )
    .transition(
      scale: 1
      duration: 10
    )

    .transition(
      top: @endLocationTop
      left: @endLocationLeft
      duration: 700
      easing: 'out'

      complete: =>
        # only continue if we are the activeSlide
        if @activeSlide
          if tools.length
            this._dropOneTool(tools)  # call until empty
          else
            this._setNextAnimationTimer()
    )

  _droptToolsInRocket: =>
    # must copy the array since dropOneTool deletes one at a time to loop
    copyArray = @$items.slice()
    this._dropOneTool(copyArray.reverse())

  _createMascot: =>
    @mascot = $('<img/>')
      .attr(src: '/images/presentation/space_mascot.svg')
      .appendTo(@el)
      .css(
        position: 'absolute'
        height: 160
        width: 160
        zIndex: -1    # not sure why we needed zIndex here, without it, it's above the rocket
#        transform: 'translateZ(40px)'     # needed for zIndex to work? not sure why
        opacity: 0
      )

  _popoutMascot: =>
    @mascot.css(
      top: @endLocationTop
      left: @endLocationLeft - 30

      opacity: 1
    )

    @mascot.transition(
      top: @toolTopOffset - 15
      duration: 1500
      easing: 'in'
      complete: =>
        @mascot.transition(
          top: @endLocationTop
          duration: 1000
          delay: 500
          easing: 'in'
          complete: =>
            this._setNextAnimationTimer(200)
        )
    )
