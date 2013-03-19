
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
      [300, 129.5],
      [352, 230.5],
      [467, 330.5],
      [511, 500.5],
      [443, 827.5],
      [334, 742.5],
      [307, 731.5],
      [334, 710.5],
      [386, 653.5],
      [360, 652.5],
      [334, 551.5],
      [364, 562.5],
      [409, 264.5],
      [571, 267.5],
      [360, 171.5],
      [293, 258.5],
      [300, 231.5],
      [275, 217.5],
      [264, 655.5],
      [250, 599.5],
      [297, 619.5],
      [513, 764.5],
      [505, 800.5],
      [173, 92.5],
      [188, 102.5],
      [219, 474.5],
      [222, 504.5],
      [307, 808.5],
      [312, 777.5],
      [489, 521.5],
      [350, 524.5],
      [358, 406.5]
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
          # removing this animation causes flicker, very lame
          # theDot.css(AmoebaSB.keyframeAnimationPlugin.animationProperty, '')

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
      .attr(class: "amoebaText")
      .css(
        fontSize: "4.5em"
        position: "absolute"
        textAlign: "center"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
        top: 500
        left: 0
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
