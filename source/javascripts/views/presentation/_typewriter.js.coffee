
class AmoebaSite.Typewriter
  # positionCSS pass in top, left, width, height (or bottom, right)
  # styleCSS is for fontSize, textAlign, textShadow, color etc
  constructor: (@parentDiv, @message, positionCSS, styleCSS) ->
    [positionCSS, @width] = positionCSS = this._cleanPositionCSS(positionCSS)
    styleCSS = this._cleanStyleCSS(styleCSS)

    @container = $('<div/>')
      .appendTo(@parentDiv)
      .addClass('typewriter')  # so we can easily find and remove all typewriters on screen
      .css(positionCSS)

    message = $('<div/>')
      .text(@message)
      .appendTo(@container)
      .attr(class: "amoebaBoldFont")
      .css(styleCSS)

  tearDown: (fadeOut=false) =>
    # convienience method
    # tearDown just removes the container div, you can also do this manually
    # if you create one and don't want to hold on to the variable
    # div = @container.find(".typewriter").remove()
    if @container
      if fadeOut
        # just keeping things DRY
        this._fadeOutAndTearDown()
      else
        @container.remove()
        @container = undefined

  _fadeOutAndTearDown: () =>
    @container.transition(
      opacity: 0
      complete: =>
        this.tearDown(false) # don't call with true unless you want an endless loop
    )

  write: (callback) =>
    @container.transition(
      width: @width
      duration: 1000

      complete: =>
        if callback
          callback()
    )

  _cleanPositionCSS: (positionCSS) =>
     # some defaults in case the user forgets to pass it a value
    defaults =
      overflow: 'hidden'
      left: 0
      top: 0
      width: 0
      height: 100
      position: "absolute"

    result = _.extend(defaults, positionCSS)

    # pull the width out and set to 0.  $message needs to be set with this width
    theWidth = result.width
    if !theWidth
      theWidth = 400 # just making debugging easier is someone forgets a width
    result.width = 0

    return [result, theWidth]

  _cleanStyleCSS: (styleCSS) =>
    # some defaults in case the user forgets to pass it a value
    defaults =
      fontSize: "1em"
      position: "absolute"
      textAlign: 'left'
      top: 0
      left: 0
      width: @width
      textShadow: "white 0px 0px 4px"
      color: "#{AmoebaSite.Colors.amoebaGreenDark}"

    return _.extend(defaults, styleCSS)
