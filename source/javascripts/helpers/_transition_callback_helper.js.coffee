class AmoebaSite.Helpers.transitionCallbackHelper
  constructor: (@clientCallback) ->
    @count = 0;

  callback: =>
    @count++
    return this._callback

  busy: =>
    return @count != 0

  _callback: =>
    @count--

    if @count == 0
      this.clientCallback?()
