jQuery ($) ->
  $(".contactus-button").on 'click', (e) ->
    PSM.contactevt()

    # Stop event propagation
    return false
