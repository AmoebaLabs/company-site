
class AmoebaSite.Typewriter
  # positionCSS pass in top, left, width, height (or bottom, right)
  constructor: (@parentDiv, @message, positionCSS, align='center') ->
    @fontSize = 1
    @textColor = "#{AmoebaSite.Colors.amoebaGreenDark}"
    @textShadow = "white 0px 0px 4px"

    # some defaults in case the user forgets to pass it a value
    theCSS =
      overflow: 'hidden'
      left: 0
      top: 0
      width: 0
      height: 100
#      backgroundColor: 'rgba(0,0,0,.2)'

      position: "absolute"

    _.extend(theCSS, positionCSS)

    # pull the width out and set to 0.  $message needs to be set with this width
    @width = theCSS.width
    if !theWidth
      theWidth = 400 # just making debugging easier is someone forgets a width
    theCSS.width = 0

    @container = $('<div/>')
      .appendTo(@parentDiv)
      .css(theCSS)

    message = $('<div/>')
      .text(@message)
      .appendTo(@container)
      .attr(class: "amoebaText")
      .css(
        fontSize: "#{@fontSize}em"
        position: "absolute"
        textAlign: align
        top: 0
        left: 0
        width: @width
        textShadow: @textShadow
        color: @textColor
      )

  tearDown: () =>
    if @container
      @container.remove()
      @container = undefined

  write: (callback) =>
    @container.transition(
      width: @width
      duration: 1000

      complete: =>
        if callback
          callback()
    )
