jQuery ($) ->

    class Transitions
      constructor: ->
        @animationTime = 1000

      homeTransition: ->
        # Slide away Nav bar
        $("#header").slideUp();

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
        $("#header").slideDown();

        # Consider scrolling to top of the page

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

    window.transitions = new Transitions();