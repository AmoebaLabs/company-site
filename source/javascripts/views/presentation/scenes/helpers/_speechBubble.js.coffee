class AmoebaSite.SpeechBubble
  constructor: (@el, @messages, positionCSS, @conversationIndex, @arrowStyle='left', @callback=null) ->
    @typewriterIndex = 0
    this._createBubble(positionCSS)

  tearDown: =>
    if @bubble?
      AmoebaSite.utils.remove(true, true, ['typewriter'], @bubble)
      @bubble = undefined

    if @bubbleContainer?
      @bubbleContainer.remove()
      @bubbleContainer = undefined

  start: =>
    @bubbleContainer.transition(
      opacity: 1
      duration: AmoebaSite.utils.dur(500)
      complete: =>
        this._nextTypewriter()
    )

  _nextTypewriter: =>
    message = @messages.shift()

    @typewriterIndex += 1

    if message?
      height = 20
      startTop = 0

      styleCss =
        textShadow: ""
        color: "white"

      css =
        left: 30
        width: 700 # can't be a percentage
        top: startTop + (height * @typewriterIndex)
        height: height

      typewriter = new AmoebaSite.Typewriter(@bubble, message, css, styleCss)
      typewriter.write(this._nextTypewriter)
    else if @callback?
      @callback(@conversationIndex)

  _createBubble: (positionCSS) =>
    @bubbleContainer = $('<div/>')
      .css(positionCSS)
      .appendTo(@el)

    if @arrowStyle == 'left'
      @bubbleContainer.addClass("left-bubble-box")
    else
      @bubbleContainer.addClass("right-bubble-box")

    @bubble = $('<div/>')
      .addClass("bubble")
      .appendTo(@bubbleContainer)
