class AmoebaSite.MascotController
  constructor: () ->

    @mascotSize = 250

    @mascot = $("#presentationMascot")
    @mascot.css(this._defaultMascotCSS())

  flyOut: () =>
    # assuming it's in the right place, just fly it out
    @mascot.transition(AmoebaSB.layout.vertOffscreen(true, { opacity: 0 }))

  flyIn: () =>
    # reset the css incase it's scaled or whatever and position
    theCSS = _.extend(this._defaultMascotCSS(), AmoebaSB.layout.center(@mascotSize, @mascotSize))

    # move outside of view using tranlateY
    theCSS = _.extend(theCSS, AmoebaSB.layout.vertOffscreen(true))

    # set the mascot
    @mascot.css(theCSS)

    # now remove the translateX/Y to make it fly in
    @mascot.transition(
      opacity: 1
      x: 0
      y: 0
    )

  slideOut: () =>
    # assuming it's in the right place, just fly it out
    @mascot.transition(AmoebaSB.layout.horizOffscreen(true, { opacity: 0 }))

  slideIn: () =>
    # reset the css incase it's scaled or whatever and position
    theCSS = _.extend(this._defaultMascotCSS(), AmoebaSB.layout.center(@mascotSize, @mascotSize, {skewX: "40deg"}))

    # move outside of view using tranlateY
    theCSS = _.extend(theCSS, AmoebaSB.layout.horizOffscreen(true))

    # set the mascot
    @mascot.css(theCSS)

    # now remove the translateX/Y to make it fly in
    @mascot.transition(
      opacity: 1
      x: 0
      y: 0
      skewX: "0deg"

      duration: 1400
    )

  zoomOut: () =>
    # assuming it's in the right place, just zoom it out
    @mascot.transition( {scale: 5, opacity: 0 })

  _defaultMascotCSS: () =>
    result =
      transform: 'translateZ(-10px)'  # z-index causes problem and flicker on animated divs, always use transformZ
      opacity: 0
      scale: 1
      width: @mascotSize
      height: @mascotSize
      position: "absolute"
      left: 0
      top: 0
      skewY: 0
      rotateX: 0
      rotateY: 0
      rotate: 0

    return result