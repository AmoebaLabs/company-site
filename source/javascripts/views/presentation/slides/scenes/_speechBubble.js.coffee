class AmoebaSite.SpeechBubble
  constructor: (@el, @messages, positionCSS, @identifier, @callback) ->
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
    )

    @typewriterIndex = 0
    this._nextTypewriter()

  _nextTypewriter: =>
    message = @messages.shift()

    @typewriterIndex += 1

    if message?
      height = 20
      startTop = 0

      css =
        padding: 10
        left: 0
        width: 600 # can't be a percentage
        top: startTop + (height * @typewriterIndex)
        height: height

      typewriter = new AmoebaSite.Typewriter(@bubble, message, css)
      typewriter.write(this._nextTypewriter)
    else if @callback?
      @callback()

  _createBubble: (positionCSS) =>
    @bubbleContainer = $('<div/>')
      .addClass("bubble-box")
      .css(positionCSS)
      .appendTo(@el)

    @bubble = $('<div/>')
      .addClass("bubble")
      .appendTo(@bubbleContainer)
