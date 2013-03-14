
# ask Bro if this is the best way to do this
AmoebaSite.utils =

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

  createTextDiv: (text, divClass, size, parentDiv, align='center') =>
    result = $('<div/>')
      .text(text)
      .addClass("amoebaText")
      .css(
        fontSize: "#{size}em"
        position: "absolute"
        textAlign: align
        top: 0
        left: 0
        opacity: 0
        width: "100%"
        textShadow: "#{AmoebaSite.Colors.amoebaGreenDark} 1px 0px 2px"
        color: "#{AmoebaSite.Colors.amoebaGreenMedium}"
      )

    if divClass
      result.addClass(divClass)

    if parentDiv
      result.appendTo(parentDiv)

    return result
