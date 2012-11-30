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

  homeTransition: (from) ->
    animate = not (from is 'none')

    # coming from contacts, get rid of header
    this._showNavBar(false, animate)
    this._scrollToOffset(0, animate)

  undoHomeTransition: (from) ->
    # Stub

  contactUsTransition: (from) ->
    animate = not (from is 'none')

    this._scrollToOffset(0, animate)

    this._showCapabilities(false, animate)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").addClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeIn(@animationTime)
    $("#contactus").removeClass("hidden")

    # Slide in Nav bar
    this._showNavBar(true, animate)

  undoContactUsTransition: (from) ->
    animate = not (from is 'none')

    this._showCapabilities(true, animate)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").removeClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeOut(@animationTime)
    $("#contactus").addClass("hidden")

  teamTransition: (from) ->
    animate = not (from is 'none')
    
    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.addClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeIn @animationTime

    this.scrollToTeamOffset(animate)

  undoTeamTransition: (from) ->
    animate = not (from is 'none')

    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.removeClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeOut @animationTime

  # also called when already in team state, but user clicks team button.  Now scrolls when button clicked
  scrollToTeamOffset: (animate = false) ->
    team = $("#team")

    # Scroll to the top of the #team div
    this._scrollToOffset(team.offset().top-150, animate)

  _isScrolling: ->
    return @scrollingCount > 0

  _scrollToOffset: (offset, animate = false) ->
    if animate
      @scrollingCount += 1;
      $('body').animate({scrollTop: "#{offset}px"}, @animationTime, 'linear', =>
        @scrollingCount -= 1

        # update after done to make sure it's in the right state
        if (not this._isScrolling())
          this.updateOnScrollEvent()
        )
    else
      $('body').scrollTop(offset)

  updateOnScrollEvent: =>
    # bail out if we are doing an animated scroll, we will update things at the end
    if this._isScrolling()
      return

    if (not @updatingOnScrollEvent)
      @updatingOnScrollEvent = true;

      callback = =>   
        # don't slide up the header if on the contact page
        if not @stateMachine.is('contact')
          if @$document.scrollTop() < @$logoNav.offset().top
            this._showNavBar(false, true)
          else 
            this._showNavBar(true, true)

        @updatingOnScrollEvent = false;

      # performance benefits from limiting this with a timer? (dan?)
      setTimeout(callback, 200)

  _showCapabilities: (show, animate = false) ->    
    $.each ["#logo", ".capabilities"], (index, klass) ->
      if show
        if animate
          $(klass).fadeIn(@animationTime)
        else
          $(klass).show()
      else
        if animate
          $(klass).fadeOut(@animationTime)
        else
          $(klass).hide()

  _showNavBar: (show, animate) ->
    if show
      if animate
        @$header.slideDown()
      else
        @$header.show()
    else
      if animate
        @$header.slideUp()
      else
        console.log("hidden");
        @$header.hide()

   
