
class AmoebaSite.Presentation.Slide_Customer extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("customerSlide")
    @transition = 'zoom'

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      this._start()

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      # reset stuff back to invisible
      @customerStepOne.tearDown()
      @customerStepOne = undefined

  _start: () =>
    @customerStepOne = new Customer_StepOne(@el, this._stepOneCallback)
    @customerStepOne.run()

  _stepOneCallback: () =>
    this._slideIsDone(1000)

class Customer_StepOne
  constructor: (parentDiv, @callback) ->
    @numSteps = 25
    @imageSize = 300
    @zoomDepth = 4000

    @manPath = '/images/presentation/man.svg'
    @questionPath = '/images/presentation/man_question.svg'
    @exclaimPath = '/images/presentation/man_exclaim.svg'

    @container = $('<div/>')
      .addClass('slide3DContainer')
      .appendTo(parentDiv)

  run: () =>
    this._doFlyInMan()

  tearDown: () =>
    if @container
      @container.remove()
      @container = undefined

  _doFlyInMan: () =>
    # counter so we know when we are all done
    @steps = 0
    @container.empty()

    masterDiv = AmoebaSite.utils.createImageDiv(@manPath, 'man', @imageSize)

    x = (@container.width() - @imageSize) / 2
    y = (@container.height() - @imageSize) / 2

    offset = 200
    this._flyIn(masterDiv, x, y, false)

  _flyIn: (masterDiv, x, y, fromRight, rotate=false) =>
    rOffset = 0
    if rotate
      rOffset = 360/(@numSteps-1)
      if fromRight
        rOffset *= -1

    r = 0

    len = (x + @imageSize)
    xOff = x - len

    if fromRight
      len = @container.width() - x
      xOff = x + len

    xOffset = len/(@numSteps-1)

    if fromRight
      xOffset *= -1

    last = false

    @steps += @numSteps

    _.each([0...@numSteps], (loopIndex) =>
      last = loopIndex == (@numSteps - 1)

      clone = masterDiv.clone()
      clone.appendTo(@container)

      t = "translateX(#{xOff}px) translateY(#{y}px) rotate(#{r}deg)"

      clone.css(
        scale: 1
        left: 0
        top: 0
        transform: t
        opacity: 0
      )

      do (last) =>
        clone.transition(
          opacity:1
          delay: loopIndex * 30
          duration: 0
          complete: =>
            if !last
              clone.transition(
                opacity: 0
                delay: 0
                duration: 800
                complete: =>
                  clone.remove()    # remove ourselves

                  this._afterFlyInStep()
              )
            else
              this._afterFlyInStep()
        )

      xOff += xOffset
      r += rOffset
    )

  _afterFlyInStep: () =>
    if --@steps == 0
      this._whoAreYou()

  _whoAreYou: () =>
    theCSS = AmoebaSite.utils.textCSSForSize(8)

    who = AmoebaSite.utils.createTextDiv("Who", theCSS, 'who', @container)
    are = AmoebaSite.utils.createTextDiv("Are", theCSS, 'who', @container)
    you = AmoebaSite.utils.createTextDiv("You?", theCSS, 'who', @container)

    height = 140
    width = 400
    top = 100

    who.css(
      top: top
      height: height
      width: width
#      backgroundColor: 'rgba(232,0,0,.2)'
    )
    top += height
    are.css(
      top: top
      height: height
      width: width
#      backgroundColor: 'rgba(0,231,0,.2)'
    )
    top += height
    you.css(
      top: top
      height: height
      width: width
#      backgroundColor: 'rgba(0,0,122,.2)'
    )
    who.transition(
      opacity: 1
      duration: 800
      complete: =>
        are.transition(
          opacity: 1
          duration: 800
          complete: =>
            you.transition(
              opacity: 1
              duration: 800
              complete: =>
                this._whoAreYouDone()
            )
          )
    )

  _fadeInQuestionMan: (thePath) =>
    this._fadeOutDivs(['man', 'who', 'typewriter'], () =>
      questionMan = AmoebaSite.utils.createImageDiv(thePath, 'man', @imageSize*2, @container)

      questionMan.css(
        scale: .5
      )
      questionMan.transition(
        top: 10
        left: 10
        opacity: 1
        scale: 1
        complete: =>
          this._fadeInQuestionManDone()
      )
    )

  _fadeOutDivs: (divClasses, fadeCallback) =>
    count = divClasses.length

    _.each(divClasses, (divClass) =>
      div = @container.find(".#{divClass}")

      div.transition(
        opacity: 0
        duration: 800
        complete: =>
          div.remove()

          count--
          if count == 0
            if fadeCallback
              fadeCallback()
      )
    )

  _typewriter: () =>
    @typewriterMode = 1
    @messages = [
      'Our ideal customer is...'
      'funded with a strong vision'

      'but, We work with you to build on your idea'
      'until you haven’t yet built out their app'
      'or maybe only have a prototype.'
      'viable product emerges through our lean, iterative approach.'
    ]

    @typewriterIndex = 0
    this._nextTypewriter()

  _typewriter2: () =>
    @typewriterMode = 2
    @messages = [
      'Other clients may have an application in the wild and have'
      'started gaining traction, but can’t hire engineering talent'
      'fast enough to build out new products.'
      'Maybe you haven’t yet built a mobile version?'
      'Or just need us to help fill the design/engineering gap.'
    ]

    @typewriterIndex = 0
    this._nextTypewriter()

  _nextTypewriter: () =>
    message = @messages.shift()

    @typewriterIndex += 1

    startTop = 100

    if message
      css =
        left: '50%'
        width: 400 # can't be a percentage
        top: startTop + (20 * @typewriterIndex)
        height: 20

      typewriter = new AmoebaSite.Typewriter(@container, message, css)
      typewriter.write(this._nextTypewriter)
    else
      this._typewriterDone()

  _typewriterDone: () =>
    if @typewriterMode == 1
      @fadeInManMode = 2
      this._fadeInQuestionMan(@exclaimPath)
    else
      if @callback
        @callback()

  _whoAreYouDone: () =>
    @fadeInManMode = 1
    this._fadeInQuestionMan(@questionPath)

  _fadeInQuestionManDone: () =>
    if @fadeInManMode == 1
      this._typewriter()
    else
      this._typewriter2()
