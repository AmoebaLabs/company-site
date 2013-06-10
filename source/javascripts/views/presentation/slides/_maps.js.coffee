
class AmoebaSite.Presentation.Slide_Map extends AmoebaSB.Slide_Base
  setup: ->
    @blipSize = 10
    this._setupElement("mapSlide")
    this._setupbackground()

    # used to create data points
    # this._enableBlipOnClick()

    this._createTextDiv()

    @transition = 'down'

  slideIn: (afterTransitionComplete) =>
    # make sure mascot comes back if entering presenation and is removed in other cases
    if afterTransitionComplete
      setTimeout =>
        this._showText()
      , 500

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._hideBlipBackground()
      @titleText.css(opacity: 0)

  _setupbackground: =>
    $('<div/>')
      .appendTo(@el)
      .attr("id", "bakgrnd")

  _showBlips: () =>
    this._showBlipBackground()

    points = [
      [300, 129],
      [352, 230],
      [467, 330],
      [511, 500],
      [443, 827],
      [334, 742],
      [307, 731],
      [334, 710],
      [386, 653],
      [360, 652],
      [334, 551],
      [364, 562],
      [409, 264],
      [571, 267],
      [360, 171],
      [293, 258],
      [300, 231],
      [275, 217],
      [264, 655],
      [250, 599],
      [297, 619],
      [513, 764],
      [505, 800],
      [173, 92],
      [188, 102],
      [219, 474],
      [222, 504],
      [307, 808],
      [312, 777],
      [489, 521],
      [350, 524],
      [358, 406]
    ]

    this._makeBlip(points)

  _makeBlip: (points) =>
    i=0
    delay = 0

    countDown = points.length

    _.each(points, (aPointArray, index) =>
      theDot = $('<span/>')
        .appendTo("div.blipDiv")
        .addClass("blipblip-dot")

      # animate a bounceIn, can't use keyframes delay, so using setTimeout
      delay += 100
      setTimeout(=>
        # set position and opacity = 1
        theDot.css(
          top: "#{aPointArray[0]}px"
          left: "#{aPointArray[1]}px"
          opacity: 1
        )

        theDot.keyframe('bounceIn', 1000, 'ease-out', 0, 1, 'normal', () =>
          theDot.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

          countDown--
          if countDown == 0
            this._slideIsDone(1000)
        )
      , delay)
    )

  _hideBlipBackground: () =>
    blipBack = $('div.blipDiv')

    # hide existing
    if blipBack.length > 0
      blipBack.remove();

  _showBlipBackground: () =>
    blipBack = $('<div/>')
      .appendTo(@el)
      .addClass("blipDiv")

  # unsed called when generating data
  _enableBlipOnClick: =>
    this._showBlipBackground()
    document.addEventListener("click", (event) =>
      blipDiv = $('div.blipDiv')
      if blipDiv.length > 0
        clickedObj = blipDiv.offset()

        left = event.pageX - clickedObj.left;
        top = event.pageY - clickedObj.top;

        # subtract half size of blip to center it on point
        left -= @blipSize/2
        top -= @blipSize/2

        console.log("[#{top}, #{left}],")

        this._makeBlip([[top, left]])
    )

  _createTextDiv: () =>
    # create text that slides down
    @titleText = $('<div/>')
      .text("in use by millions of people across the world.")
      .appendTo(@el)
      .attr(class: "amoebaBoldFont")
      .css(
        fontSize: "4.5em"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
        top: 500
        left: 0
        width: '100%'
        opacity: 0
      )

  _showText: () =>
    @titleText.css(
      opacity: 1
    )

    @titleText.keyframe('bounceInDown', 800, 'ease-out', 0, 1, 'normal', () =>
      @titleText.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

      setTimeout =>
        this._showBlips(true)
      , 500
    )
