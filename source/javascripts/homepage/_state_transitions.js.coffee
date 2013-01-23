class Amoeba.StateTransitions
  constructor: (@stateMachine) ->
    @animationTime = 1000
    @scrollingCount = 0
    this._cacheElements()

  _cacheElements: ->
    @$header = $("#header")
    @$footer = $("#footer")
    @$team = $("#team")
    @$mascot = $("#mascot")
    @$contactus = $("#contactus")
    @$contactQuestions = $("#contact-questions")
    @$logoNav = $("#logo nav")
    @$logo = $("#logo")
    @$document = $(document)

  homeTransition: (from) ->
    animate = not (from is 'none')

    # coming from contacts, get rid of header
    this._showNavBar(false, animate)
    this._scrollToOffset(0, animate)

    this._showCapabilities(true, animate)
    @$footer.show()
    @$mascot.show()
    @$logo.show()

  undoHomeTransition: (to) ->
    # Stub

  contactUsTransition: (from) ->
    animate = not (from is 'none')
    animationTime = if animate then @animationTime else 0

    this._scrollToOffset(0, animate)

    this._showCapabilities(false, animate)

    # .contactus is used to position the mascot for the contactus form
    @$mascot.addClassWithTransition
      className: "contactus",
      duration: @animationTime

    @$mascot.show()

    # Show the sayhi & contactus divs
    @$contactQuestions.fadeIn(@animationTime)
    @$contactus.removeClass("hidden").playKeyframe
        name: 'contactus-in'
        duration: @animationTime
        easing: 'ease-in'

    # Slide in Nav bar
    this._showNavBar(true, animate)

  undoContactUsTransition: (to) ->
    @$mascot.hide() unless to is 'home'

    # .contactus is used to position/ animate the mascot for the contactus form
    @$mascot.removeClassWithTransition
      className: "contactus",
      duration: if to is 'home' then @animationTime else 0

    # Show the sayhi & contactus divs
    @$contactQuestions.fadeOut(@animationTime)
    @$contactus.addClass("hidden")

  teamTransition: (from) ->
    animate = not (from is 'none')
    animationTime = if animate then @animationTime else 0

    # Scroll to top if we're animating (not an initial page load)
    @scrollToTop() if animate

    # Slide in Nav bar
    this._showNavBar(true, animate)

    # Hide homepage top elements
    this._showCapabilities(false, animate)
    @$mascot.fadeOut animationTime, =>
      # Show team, after homepage elements are gone
      @$team.removeClass("hidden").playKeyframe
        name: 'team-in'
        duration: @animationTime

    # Move footer
    @$footer.fadeOut animationTime, =>
      @$footer.addClass("team")
      @$footer.show()

  undoTeamTransition: (to) ->
    # Move footer
    @$footer.hide()
    @$footer.removeClass("team")
    @$footer.fadeIn(@animationTime)

    # Hide team
    @$team.addClass("hidden")

  scrollToTop: ->
    this._scrollToOffset(0, true)

  _isScrolling: ->
    return @scrollingCount > 0

  _scrollToOffset: (offset, animate = false) ->
    if animate
      @scrollingCount += 1;
      $('body, html').animate({scrollTop: "#{offset}px"}, @animationTime, 'swing', =>
        @scrollingCount -= 1
        )
    else
      $('body, html').scrollTop(offset)

  _showCapabilities: (show, animate = false) ->
    animationTime = if animate then @animationTime else 0
    $.each ["#logo", ".capabilities"], (index, klass) =>
      if show
        $(klass).fadeIn(animationTime)
      else
        $(klass).fadeOut(animationTime)

  _showNavBar: (show, animate) ->
    animationTime = if animate then 400 else 0
    if show
      @$header.slideDown(animationTime)
    else
      @$header.slideUp(animationTime)

   
