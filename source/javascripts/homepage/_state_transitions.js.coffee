class Amoeba.StateTransitions
  constructor: ->
    @animationTime = 1000

  homeTransition: ->
    # coming from contacts, get rid of header
    $("#header").slideUp()

  undoHomeTransition: ->
    # Stub

  contactUsTransition: ->
    $('body,html').animate({scrollTop: '0px'}, @animationTime)

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

  #called when already in team state, but user clicks team button.  Now scrolls when button clicked
  scrollToTeamOffset: ->
    team = $("#team")

    # Scroll to the top of the #team div
    teamOffset = team.offset().top-150
    $('body,html').animate({scrollTop: "#{teamOffset}px"}, @animationTime)

  _showCapabilities: (show) ->    
    $.each ["#logo", ".capabilities"], (index, klass) ->
      if show
        $(klass).fadeIn(@animationTime)
      else
        $(klass).fadeOut(@animationTime)
