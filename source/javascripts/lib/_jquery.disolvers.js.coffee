$ = jQuery

$.fn.disolveIn = (duration=1000, callback=null) ->
  this.removeClass("hidden")

  # warning, callback must always be called to be compatible with code that relies on this behavior
  this.transition
    opacity: 1
    duration: duration
    complete: ->
      callback?()

$.fn.disolveOut = (duration=1000, callback=null) ->
  # warning, callback must always be called to be compatible with code that relies on this behavior
  this.transition
    opacity: 0
    duration: duration
    complete: =>
      this.addClass("hidden")
      callback?()
