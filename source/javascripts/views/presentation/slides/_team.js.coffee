
class AmoebaSite.Presentation.Slide_Team extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("teamSlide")
    @transition = 'zoom'

    @button = $('<button/>')
      .text('Again')
      .appendTo(@el)
      .css(
        position: 'absolute'
        bottom: 20
        right: 20
        width: 100
        zIndex: 400
      )
      .click( (event) =>
        this._tripWalker()
      )

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      if @tripWalker
        @tripWalker.tearDown()
        @tripWalker = undefined

      if @typewriter
        @typewriter.tearDown()
        @typewriter = undefined

  _start: () =>
    # create this on step one.
    # We remove from the array for each message to avoid having to keep track of the current index
    @messages = [
      "We Are Flexible...",
      "We Get out of your way...",
      "We Move Fast...",
      "We build it for YOU!"
    ]

    # start the trip walker and it sends callbacks for the message timing
    @tripWalker = new AmoebaSite.TripWalker(@el, '/images/presentation/man.svg', this._tripWalkerCallback).run()

  # return false when no more messages
  _showNextMessage: () =>
    message = @messages.shift()
    if message
      this._typewriterEffect(message)
      return true

    return false

  # callback on start, at segment breaks and at the end
  _tripWalkerCallback: (done) =>
    success = this._showNextMessage()

#    if !success
#      console.log 'no more messages'

    if done
#      console.log 'trip walker done'
      this._slideIsDone(1000)

  _typewriterCallback: () =>
    console.log 'typewriter callback'

  _typewriterEffect: (message, bottom) =>
    # fade out current message if any
    @typewriter?.tearDown(true) # true fades it out before it removes it from the DOM

    positionCSS =
      position: 'absolute'
      top: 100
      left: 300
      height: 200
      width: 400

    styleCSS =
      textAlign: 'center'
      fontSize: '2em'

    @typewriter = new AmoebaSite.Typewriter(@el, message, positionCSS, styleCSS)
    @typewriter.write(this._typewriterCallback)
