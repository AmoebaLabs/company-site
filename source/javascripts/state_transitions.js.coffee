jQuery ($) ->

    class Transitions

      homeTransition: ->
        # Slide away Nav bar
        $("#header").slideUp();

      contactUsTransition: ->
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

    transitions = new Transitions();