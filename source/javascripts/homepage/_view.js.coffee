class Amoeba.HomepageView
  stateTransitions: new Amoeba.StateTransitions

  constructor: ->
    this.cacheElements()
    this.initStateMachine()
    this.bindEvents()

  cacheElements: ->
    @$header = $("#header")
    @$logoNav = $("#logo nav")
    @$document = $(document)

  bindEvents: ->
    # Slide in Header when scrolled down far enough
    @$document.on 'scroll.header', =>
      this._updateOnScrollEvent()

  initStateMachine: ->
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

  showContact: -> 
    @stateMachine.contactevt()
  
  showTeam: -> 
    # we are already team, but user clicks again on team button, scroll to right place to avoid doing nothing
    if (@stateMachine.is('team'))
      @stateTransitions.scrollToTeamOffset();
      
    @stateMachine.teamevt()

  showHome: -> 
    @stateMachine.homeevt()

  _updateOnScrollEvent: ->
    if (not @updatingOnScrollEvent)
      @updatingOnScrollEvent = true;

      callback = =>   
        # don't slide up the header if on the contact page
        if not @stateMachine.is('contact')
          if @$document.scrollTop() < @$logoNav.offset().top
            @$header.slideUp()
          else 
            @$header.slideDown()

        @updatingOnScrollEvent = false;

      # performance benefits from limiting this with a timer? (dan?)
      setTimeout(callback, 200)

      
   