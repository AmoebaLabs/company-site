class Amoeba.StateTransitions
  constructor: (@stateMachine) ->
    @animationTime = 1000
    @scrollingCount = 0
    @updatingOnScrollEvent = false
    this._cacheElements()

  _cacheElements: ->
    @$header = $("#header")
    @$logoNav = $("#logo nav")
    @$document = $(document)

  homeTransition: ->
    # coming from contacts, get rid of header
    $("#header").slideUp()

  undoHomeTransition: ->
    # Stub

  contactUsTransition: ->
    this.animatedScrollToOffset(0)

    this._showCapabilities(false)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").addClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeIn(@animationTime)
    $("#contactus").removeClass("hidden")

    # Slide in Nav bar
    $("#header").slideDown()

  undoContactUsTransition: ->
    this._showCapabilities(true)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").removeClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeOut(@animationTime)
    $("#contactus").addClass("hidden")

  teamTransition: ->
    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.addClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeIn @animationTime

    this.scrollToTeamOffset()

  undoTeamTransition: ->
    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.removeClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeOut @animationTime

  # also called when already in team state, but user clicks team button.  Now scrolls when button clicked
  scrollToTeamOffset: ->
    team = $("#team")

    # Scroll to the top of the #team div
    this.animatedScrollToOffset(team.offset().top-150)

  isScrolling: ->
    return @scrollingCount > 0

  animatedScrollToOffset: (offset) ->
    @scrollingCount += 1;
    $('body').animate({scrollTop: "#{offset}px"}, @animationTime, 'linear', =>
      @scrollingCount -= 1

      # update after done to make sure it's in the right state
      if (not this.isScrolling())
        this.updateOnScrollEvent()
      )

  updateOnScrollEvent: =>
    # bail out if we are doing an animated scroll, we will update things at the end
    if this.isScrolling()
      return

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

  _showCapabilities: (show) ->    
    $.each ["#logo", ".capabilities"], (index, klass) ->
      if show
        $(klass).fadeIn(@animationTime)
      else
        $(klass).fadeOut(@animationTime)

   
