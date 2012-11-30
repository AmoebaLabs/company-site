class Amoeba.HomepageView
  constructor: ->
    @animationTime = 1000
    this._cacheElements()
    this._initStateMachine()
    this._bindEvents()

  _cacheElements: ->
    @$document = $(document)
    @$capabilityBox = $('.capability-box')

  _bindEvents: ->
    # Slide in Header when scrolled down far enough
    @$document.on 'scroll.header', =>
      @stateTransitions.updateOnScrollEvent(@stateMachine)

    # Capabilities hovers
    @$capabilityBox.hover (e) ->
        $(this).find('.rollover').fadeOut(@animationTime)
      ,(e) ->
        $(this).find('.rollover').fadeIn(@animationTime)


  _initStateMachine: ->
    @stateMachine = StateMachine.create(

      events: [
        name: "contactevt"
        from: StateMachine.WILDCARD
        to: "contact"
      ,
        name: "homeevt"
        from: StateMachine.WILDCARD
        to: "home"
      ,
        name: "teamevt"
        from: StateMachine.WILDCARD
        to: "team"
      ]

      callbacks:
        oncontact: (event, from, to) =>
          @stateTransitions.contactUsTransition()

        onhome: (event, from, to) =>
          @stateTransitions.homeTransition()

        onteam: (event, from, to) =>
          @stateTransitions.teamTransition()

        onleavecontact: (event, from, to) =>
          @stateTransitions.undoContactUsTransition()

        onleaveteam: (event, from, to) =>
          @stateTransitions.undoTeamTransition()
    )

    @stateTransitions = new Amoeba.StateTransitions(@stateMachine)

  showContact: -> 
    @stateMachine.contactevt()
  
  showTeam: -> 
    # we are already team, but user clicks again on team button, scroll to right place to avoid doing nothing
    if (@stateMachine.is('team'))
      @stateTransitions.scrollToTeamOffset();

    @stateMachine.teamevt()

  showHome: -> 
    @stateMachine.homeevt()

