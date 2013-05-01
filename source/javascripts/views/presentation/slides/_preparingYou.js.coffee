# global, could be removed once finalize
AmoebaSite.simpleRotation = false

class AmoebaSite.Presentation.Slide_PreparingYou extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("preparingYouSlide")
    @transition = 'zoom'

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      @cube.tearDown()
      @cube = undefined

    # removes the messages
    AmoebaSite.utils.remove(true, false, ['message'], @el)

  _start: () =>
    @cube = new AmoebaSite.CubeController(@el, this._cubeCallback)

  # overriding pause/next/previous to handle the cube
  pause: () =>
    if @cube
      return @cube.pause()

    return false

  next: () =>
    if @cube
      return @cube.next()

    return false

  previous: () =>
    if @cube
      return @cube.previous()

    return false

  _cubeCallback: () =>
    sentence = "As the client hires developers, we include them on our team, at our offices. As integrated team members, our client's develop- ers are trained on the processes, tools and technologies they will need to continue development after version 1.0 and beyond."

    theCSS = AmoebaSite.utils.textCSSForSize(4, 'left')
    title = AmoebaSite.utils.createTextDiv("Preparing You", theCSS, 'message', @el)
    theCSS = AmoebaSite.utils.textCSSForSize(1.3, 'left')
    message = AmoebaSite.utils.createTextDiv(sentence, theCSS, 'message', @el)

    title.css(
      top:70
      left: '50%'
    )
    title.transition(
      opacity: 1
      duration: 800
    )

    message.css(
      top:450
      left: '50%'
      width: 450
    )
    message.transition(
      opacity: 1
      duration: 800
      complete: =>
        this._slideIsDone(1000)
    )

