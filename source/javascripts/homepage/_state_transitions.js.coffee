class Amoeba.StateTransitions
  constructor: ->
    @animationTime = 1000

  homeTransition: ->
    # Stub

  undoHomeTransition: ->
    # Stub

  contactUsTransition: ->
    this._showCapabilities(false)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").addClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeIn(@animationTime)
    $("#contactus").removeClass("hidden")

    # Slide in Nav bar
    $("#header").slideDown()

    # scroll to top of page
    $("body").scrollTop(0)

  undoContactUsTransition: ->
    this._showCapabilities(true)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").removeClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeOut(@animationTime)
    $("#contactus").addClass("hidden")

    # Slide in Nav bar
    $("#header").slideUp()

  teamTransition: ->
    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.addClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeIn @animationTime

    # Scroll to the top of the #team div
    teamOffset = team.offset().top-150
    $('body,html').animate({scrollTop: '+=' + teamOffset + 'px'}, @animationTime)

  undoTeamTransition: ->
    # Move footer
    footer = $("#footer")
    footer.fadeOut @animationTime, ->
      footer.removeClass("team")
      footer.show()

    # Show team
    team = $("#team")
    team.fadeOut @animationTime
        
  _showCapabilities: (show) ->    
    $.each ["#logo", ".capabilities"], (index, klass) ->
      if show
        $(klass).fadeIn(@animationTime)
      else
        $(klass).fadeOut(@animationTime)
