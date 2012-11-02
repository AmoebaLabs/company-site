//= require state-machine

jQuery ($) ->
  window.STH = StateMachine.create(
    initial: "home"
    events: [
      name: "contactevt"
      from: "home"
      to: "contact"
    ,
      name: "homeevt"
      from: "contact"
      to: "home"
    ]

    callbacks:
      # Events
      onbeforecontactevt: (event, from, to) ->
        console.log "STARTING UP"

      oncontactevt: (event, from, to) ->
        console.log "READY"

      onbeforehomeevt: (event, from, to) ->
        console.log "STARTING UP"

      onhomeevt: (event, from, to) ->
        console.log "READY"

      # State changes
      onleavecontact: (event, from, to) ->
        console.log "LEAVE   STATE: contact"

      onleavehome: (event, from, to) ->
        console.log "LEAVE   STATE: home"

      oncontact: (event, from, to) ->
        console.log "ENTER   STATE: contact"
        showContact()

      onhome: (event, from, to) ->
        console.log "ENTER   STATE: home"
        #showHome()

      onchangestate: (event, from, to) ->
        console.log "CHANGED STATE: " + from + " to " + to
    )

  showHome = () ->
    transitions.contactUsTransition();

  showContact = () ->
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

