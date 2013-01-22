class Amoeba.HomepageView
  constructor: ->
    @animationTime = 1000

    this._cacheElements()
    this._initStateMachine()
    this._bindEvents()

  _cacheElements: ->
    @$document = $(document)
    @$capabilityBox = $('.capability-box')
    @$mascot = $('#mascot')

  _bindEvents: ->
    # Capabilities hovers
    @$capabilityBox.hover (e) ->
        $(this).find('.rollover').fadeOut(@animationTime)
      ,(e) ->
        $(this).find('.rollover').fadeIn(@animationTime)

    # Mobile navigation
    $("#mobile-button").on 'click', ->
      $("#mobile-nav").slideToggle(@animationTime)

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
          @stateTransitions.contactUsTransition(from)

        onhome: (event, from, to) =>
          @stateTransitions.homeTransition(from)

        onteam: (event, from, to) =>
          @stateTransitions.teamTransition(from)

        onleavecontact: (event, from, to) =>
          @stateTransitions.undoContactUsTransition(to)

        onleaveteam: (event, from, to) =>
          @stateTransitions.undoTeamTransition(to)
    )

    @stateTransitions = new Amoeba.StateTransitions(@stateMachine)

  showContact: -> 
    @stateMachine.contactevt()
  
  showTeam: ->
    # Scroll to top to avoid doing nothing if we're already on team
    @stateTransitions.scrollToTop() if @stateMachine.is('team')
    # Fire transition event
    @stateMachine.teamevt()

  showHome: -> 
    @stateMachine.homeevt()

  submitForm: (req) ->
    $name = $("input#contact-name")
    $company = $("input#contact-company")
    $email = $("input#contact-email")
    $message = $("textarea#contact-message")
    $error = $('.error-message')

    $error.addClass("invisible")

    if ($name.val() == "")
      $name.focus()
      $error.html("You must enter a valid name.")
      $error.removeClass("invisible")
      return false

    if ($company.val() == "")
      $company.focus()
      $error.html("You must enter a company.")
      $error.removeClass("invisible")
      return false

    emailRE = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

    if ($email.val() == "" || !emailRE.test($email.val()))
      $email.focus()
      $error.html("You must enter a valid email.")
      $error.removeClass("invisible")
      return false

    if ($message.val() == "")
      $message.focus()
      $message.html("You must enter a message.")
      $message.removeClass("invisible")
      return false

    dataString = "name=#{$name.val()}&email=#{$email.val()}&company=#{$company.val()}&message=#{$message.val()}"
    $.ajax
      type: "POST"
      url: "/submit_contact.php"
      data: dataString
      success: =>
        $error.addClass("success")
        $error.html("Success!")
        $error.removeClass("invisible")
        setTimeout =>
          req.redirect "/"
          $error.removeClass("success")
          $error.addClass("invisible")
          $name.val("")
          $company.val("")
          $email.val("")
          $message.val("")
        , 2000
      error: =>
        $error.html("Error: Invalid response. Please try again.")
        $error.removeClass("invisible")

