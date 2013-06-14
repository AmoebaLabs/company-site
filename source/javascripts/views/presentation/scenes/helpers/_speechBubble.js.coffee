class AmoebaSite.SpeechBubble
  constructor: (@el, @message, positionCSS, @conversationIndex, @arrowStyle='left', @callback=null) ->
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
      duration: AmoebaSite.utils.dur(1000)
      complete: =>
        this._typeText()
    )

  _typeText: =>
    srcText = @message
    i = 0
    result = ""
    interval = setInterval(=>
      if (i == srcText.length)
        clearInterval(interval)

        # delay at the end a bit so it doesn't disappear so fast
        setTimeout(=>
          @callback?(@conversationIndex)
        , AmoebaSite.utils.dur(1000))
      else
        result += srcText[i].replace("\n", "<br />")
        $(".bubbleText").html( result)

        i++
    , AmoebaSite.utils.dur(30))

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

    @text = $('<div/>')
      .addClass("bubbleText")
      .appendTo(@bubble)
