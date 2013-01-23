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
    this._divShow(@$mascot, if animate then @animationTime else 0)
    @$logo.show()

  undoHomeTransition: (to) ->
    # Stub

  contactUsTransition: (from) ->
    animate = not (from is 'none')
    animationTime = if animate then @animationTime else 0

    this._scrollToOffset(0, animate)

    this._showCapabilities(false, animate)

    this._divShow(@$mascot, animationTime)

    if from is 'home'
      @$mascot.addClassWithTransition
        className: "contactus",
        duration: @animationTime
    else
      @$mascot.addClass("contactus")  # coming from team is transitioning opacity:1 which interferes with this animation

    # Show the sayhi & contactus divs
    @$contactQuestions.fadeIn(@animationTime)

    @$contactus.removeClass("hidden")
    @$contactus.css {perspective: '400px', opacity: 0, rotateY: '-90deg'}
    @$contactus.transition {perspective: '400px', opacity: 1, rotateY: '0deg'}, @animationTime, 'ease-in'

    # Slide in Nav bar
    this._showNavBar(true, animate)

  undoContactUsTransition: (to) ->
    if to is 'home'
      @$mascot.removeClassWithTransition
        className: "contactus",
        duration: @animationTime
    else
      @$mascot.transition {opacity: 0}, @animationTime, =>
        @$mascot.removeClass("contactus")

    # Show the sayhi & contactus divs
    @$contactQuestions.fadeOut(@animationTime)

    @$contactus.transition {opacity: 0}, @animationTime, =>
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


    @$mascot.transition {opacity: 0}, animationTime, =>
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

  _divShow: (jqueryObj, duration) =>
    jqueryObj.removeClass("hidden")

    if jqueryObj.css('opacity') != "1"
      console.log("fuck me")

      jqueryObj.transition {opacity: 1}, duration
    else
      console.log(" anit doing shit")

  _divHide: (jqueryObj, duration) =>
    if jqueryObj.css('opacity') != "0"
      jqueryObj.transition {opacity: 0}, duration, =>
        jqueryObj.addClass("hidden")

