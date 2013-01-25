$ = jQuery

$.fn.disolveIn = (duration, callback) ->
  this.removeClass("hidden")
  if this.css('opacity') != "1"
    this.transition
      opacity: 1
      duration: duration
      complete: ->
        callback?()

$.fn.disolveOut = (duration, callback) ->
  if this.css('opacity') != "0"
    this.transition
      opacity: 0
      duration: duration
      complete: =>
        this.addClass("hidden")
        callback?()
  else
    this.addClass("hidden")