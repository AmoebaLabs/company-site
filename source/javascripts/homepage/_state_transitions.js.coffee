class Amoeba.StateTransitions
  constructor: ->
    @animationTime = 1000

  homeTransition: ->
    $("#homepage").removeClass("hidden")

  undoHomeTransition: ->
    $("#homepage").addClass("hidden")

  contactUsTransition: ->
    # Must hide the unnecessary elements
    $.each ["#logo", ".capabilities"], (index, klass) ->
      $(klass).fadeOut(@animationTime)

    # .contactus is used to position/ animate the mascot for the contactus form
    $("#mascot").addClass("contactus")

    # Show the sayhi & contactus divs
    $("#contact-questions").fadeIn(@animationTime)
    $("#contactus").removeClass("hidden")

    # Slide in Nav bar
    $("#header").slideDown()

  # Consider scrolling to top of the page

  undoContactUsTransition: ->
    # Must hide the unnecessary elements
    $.each ["#logo", ".capabilities"], (index, klass) ->
      $(klass).fadeIn(@animationTime)

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
        