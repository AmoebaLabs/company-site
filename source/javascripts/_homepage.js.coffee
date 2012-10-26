jQuery ($) ->
  $(".contactus-button").on 'click', (e) ->
    PSM.contactevt()

    # Stop event propagation
    return false

window.showContact = () ->
  animationTime = 1000

  # Must hide the unnecessary elements
  $.each ["#logo", ".capabilities"], (index, klass) ->
    $(klass).fadeOut(animationTime)

  # .contactus is used to position/ animate the mascot for the contactus form
  $("#mascot").addClass("contactus")

  # Show the sayhi & contactus divs
  $("#contact-questions").fadeIn(animationTime)
  $("#contactus").removeClass("hidden")

  # Slide in Nav bar
  $("#header").slideDown();

  # Consider scrolling to top of the page
