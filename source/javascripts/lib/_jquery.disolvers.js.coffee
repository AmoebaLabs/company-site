$ = jQuery

# warning, callback must always be called to be compatible with code that relies on this behavior
$.fn.disolveIn = (duration, callback) ->
  this.removeClass("hidden")

  if this.css('opacity') == "1"
    # transition will run for the duration even if already in the correct state
    # so just call the callback and return immediately
    callback?()
  else
    this.transition
      opacity: 1
      duration: duration
      complete: ->
        callback?()

# warning, callback must always be called to be compatible with code that relies on this behavior
$.fn.disolveOut = (duration, callback) ->
  if this.css('opacity') == "0"
    # transition will run for the duration even if already in the correct state
    # so just call the callback and return immediately
    callback?()
  else
    this.transition
      opacity: 0
      duration: duration
      complete: =>
        this.addClass("hidden")
        callback?()
