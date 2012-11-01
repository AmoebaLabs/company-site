jQuery ($) ->
  $(".contactus-button").on 'click', (e) ->
    STH.contactevt()

    # Stop event propagation
    return false
