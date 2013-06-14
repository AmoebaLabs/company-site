
AmoebaSite.utils =
  dur: (duration) =>
    multiplier = .2  # speed up animations for testing, 1 is normal speed
    return duration * multiplier

  createImageDiv: (path, divClass, imageSize, parentDiv) =>
    result = $('<div/>')
      .css(
        backgroundImage: 'url("' + path + '")'
        backgroundPosition: 'center center'
        backgroundSize: 'contain'
        backgroundRepeat: 'no-repeat'
        top: 0
        left: 0
        position: "absolute"
        width:imageSize
        height: imageSize
        opacity: 0
      )

    if divClass
      result.addClass(divClass)

    if parentDiv
      # center if we have a parent, some code uses this
      result.css(
        top: (parentDiv.height() - imageSize) / 2
        left: (parentDiv.width() - imageSize) / 2
      )

      result.appendTo(parentDiv)

    return result

  defaultTextCSS: () =>
    result =
      fontSize: "1em"
      position: "absolute"
      textAlign: 'center'
      top: 0
      left: 0
      opacity: 0
      width: "100%"
      textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
      color: "#{AmoebaSite.Colors.amoebaGreenMedium}"

    return result

  textCSSForSize:(size=1, align='center') =>
    result =
      fontSize: "#{size}em"
      textAlign: align

    return result

  deepTextShadowCSS: () =>
    shadowString = "0 1px 2px rgba(0, 0, 0, .8),"
    # loop and create progressivly darker shadows
    _.each([2..6], (element, index) =>
      # x, y, blur, color
      shadowString += "0 #{element}px 0 rgba(#{255 - (12*element)}, #{255 - (12*element)}, #{255 - (12*element)}, 1.0), "
    )

    shadowString += "0 7px 7px rgba(0, 0, 0, 0.4),"
    shadowString += "0 8px 10px rgba(0, 0, 0, 0.2)"

    result =
      textShadow: shadowString

    return result

  # searchClass is used for finding all text divs with a set class
  # for removal. example: $(".#{styleClass}").remove()
  # styleClass is used for styling
  createTextDiv: (text, css, searchClass, parentDiv) =>
    # css overrides the defaults (color, shadow, etc)
    theCSS = AmoebaSite.utils.defaultTextCSS()
    if css?
      theCSS = _.extend(theCSS, css)

    result = $('<div/>')
      .text(text)
      .css(theCSS)

    # set the font
    result.addClass('amoebaBoldFont')

    if searchClass
      result.addClass(searchClass)

    if parentDiv
      result.appendTo(parentDiv)

    return result

  hideDiv: (theDiv, show) =>
    theDiv.css(
      display: if show == true then 'block' else 'none'
    )

  remove: (remove, fadeOut, divClasses, parentDiv, callback) =>
    if not parentDiv?
      return

    count = divClasses.length

    _.each(divClasses, (divClass) =>
      div = parentDiv.find(".#{divClass}")

      if fadeOut
        div.transition(
          opacity: 0
          duration: 800
          complete: =>
            if remove
              div.remove()

            count--
            if count == 0
              if callback
                callback()
        )
      else
        if remove
          div.remove()
    )
