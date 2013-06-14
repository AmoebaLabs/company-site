
class AmoebaSite.Views.Homepage.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentationIntro'

  initialize: ->
    this._setupProgressBar()

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @helpers.scrollToTop(animationTime)
    @parent.hideFooter(animationTime)

    this._positionMascot(animationTime)

    @$el.disolveIn(0)

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    if AmoebaSite.presentation?
      AmoebaSite.presentation.tearDown()
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut(0)

  _setupProgressBar: () =>
    @progressIndex = 0
    @progressSteps = 6

     # progress bar at bottom
    $('<div/>')
      .appendTo(@el)
      .attr({id: "progressBar"})
      .html('<span></span>')
      .click( (event) =>
        console.log 'clicked progress bar'
      )

    # listen for events to increment progress
    $('body').on('amoeba:incrementProgressBar', =>
      @progressIndex++

      ratio = @progressIndex / (@progressSteps - 1)

      $("#progressBar span").css(width: "#{ratio * window.innerWidth}px")
    )

  _openCurtains: (showPresentation) =>
    if showPresentation
      @parent.mascot.hide(@parent.animationTime)

      curtains = new AmoebaSite.Curtains($("body"), false, (step) =>
        switch step
          when '2'
            if not AmoebaSite.presentation?
              pres = $('#presentation')
              pres.disolveIn(0)  # just need class=hidden removed
              AmoebaSite.presentation = new AmoebaSite.SceneController(pres, =>
                this._openCurtains(false)
              )
              AmoebaSite.presentation.start()

          when 'done'
            # delay a bit so it's not so fast a transition
            setTimeout( =>
              curtains.tearDown()
            , AmoebaSite.utils.dur(1000))
      )
    else
      curtains = new AmoebaSite.Curtains($("body"), true, (step) =>
        switch step
          when '1'
            # switch to home page
            Backbone.history.navigate("/", trigger: true);

            pres = $('#presentation')
            pres.disolveOut(0)  # just need class=hidden added back

          when 'done'
            curtains.tearDown()
      )

  _startConversation: =>
    this._typewriter(1)

  _typewriter: (conversationIndex) =>
    left = 10
    arrowStyle = 'left'

    if conversationIndex == 1
      messages = [
        "Hi, I’m Amoeba"
        "I work with early stage technology companies"
        "to transform their idea into a minimum viable product"
      ]
    else if conversationIndex == 2
      messages = [
        "Get it done in weeks, not months"
        "( or god forbid, years )"
      ]
    else
      left = 500
      arrowStyle = 'right'

      messages = [
        'How the hell do you do that?'
        "Tell me more..."
      ]

    positionCSS =
      top: 10
      left: left
      height: 100
      width: 400

    @speechBubble = new AmoebaSite.SpeechBubble(@el, messages, positionCSS, conversationIndex, arrowStyle, this._speechBubbleCallback)
    @speechBubble.start()

  _speechBubbleCallback: (conversationIndex) =>
    if @speechBubble?
      @speechBubble.tearDown()
      @speechBubble = undefined

    if conversationIndex == 1
      this._typewriter(2)
    else if conversationIndex == 2
      this._slideInCustomer()
    else
      this._slideOutCustomer()

  _slideInCustomer: =>
    this._createCustomer()

    @customer
      .css({ transformOrigin: '50% 100%' })
      .transition(
        rotate: "-40deg"
        duration: AmoebaSite.utils.dur(3000)

        complete: =>
          mascot = @parent.mascot.$el

          # move the mascot x pixels to the right of mascot
          right = window.innerWidth - mascot.offset().left;
          right -= mascot.width()
          right -= 50
          right -= @customer.width()

          @customer.transition(
            right: right
            duration: AmoebaSite.utils.dur(3000)

            complete: =>
              this._typewriter(3);
          )
      )

  _slideOutCustomer: =>
    @customer.transition(
      opacity: 0
      duration: AmoebaSite.utils.dur(2000)

      complete: =>
#       Backbone.history.navigate("/", trigger: true)
        this._openCurtains(true)
    )

  _createCustomer: =>
    mascot = @parent.mascot.$el
    offset = mascot.offset()

    @customer = $('<img/>')
      .attr(src: '/images/presentation/biz_guy.svg')
      .appendTo(@el)
      .css(
        position: 'fixed'
        top: offset.top
        right: 0
        height: 400
        width: 400
      )

  _positionMascot: (animationTime) =>
    mascot = @parent.mascot.$el

    @parent.mascot.show(animationTime)
    mascot.transition(
      top: 200
      left: 0
      height: 400
      width: 400
      duration: animationTime
      complete: =>
        this._startConversation()
    )

