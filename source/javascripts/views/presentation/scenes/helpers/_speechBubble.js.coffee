class AmoebaSite.SpeechBubble
  constructor: (@el, @messages, positionCSS, @conversationIndex, @arrowStyle='left', @callback=null) ->
    this._createBubble(positionCSS)

  tearDown: =>
    if @bubble?
      @bubble = undefined

    if @bubbleContainer?
      @bubbleContainer.remove()
      @bubbleContainer = undefined

  start: =>
    @bubbleContainer.transition(
      opacity: 1
      duration: AmoebaSite.utils.dur(1000)
      complete: =>
        this._typeText(0)
    )

  _typeText: (duration=1000)=>
    setTimeout(=>
      if @messages.length
        this._typeSentence(@messages.shift())
      else
        @callback?(@conversationIndex)
    , AmoebaSite.utils.dur(duration))

  _typeSentence: (srcText) =>
    i = 0
    result = ""
    interval = setInterval(=>
      if (i == srcText.length)
        clearInterval(interval)

        # delay at the end a bit so it doesn't disappear so fast
        this._typeText();
      else
        result += srcText[i].replace("\n", "<br />")
        $(".bubbleText").html( result)

        i++
    , AmoebaSite.utils.dur(20))

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
