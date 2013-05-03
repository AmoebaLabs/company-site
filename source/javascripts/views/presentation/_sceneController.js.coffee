#= require_tree ./scenes

class AmoebaSite.SceneController
  constructor: (@el) ->
    AmoebaSB.layout ?= new AmoebaSB.SlideLayout($("#stage"), $('#stageHolder'))
    @backgroundColorClasses = 'white black blue green, none'

  start: =>
    this.setBackground('default')

    @home = new AmoebaSite.HomeScene(@el.find('#content'), =>
      console.log 'home callback called'
    )

  tearDown: =>
    @home.tearDown()
    @home = undefined

  setBackgroundColor: (color) =>
    parent = $("#presentation")

    parent.removeClass(@backgroundColorClasses)

    parent.css(
      backgroundColor: color
    )

  setBackground: (colorClass) =>
    if colorClass == 'default'
      colorClass = 'none'

    # remove any in flight transition if any
    this._removeBackgroundDiv()

    # use a fresh div every time.  That way if we can call this twice in a row
    # without worrying about halting an inflight transition
    @backgroundDiv = $('<div/>')
      .addClass(colorClass)
      .css(
        opacity: 0
        height: '100%'
        width: '100%'
      )
      .appendTo($('#presentationBackground'))

    @backgroundDiv.transition(
      opacity: 1
      duration: 2000
      complete: =>
        # now set the presentation view to match the now faded in background, and remove the background
        parent = $("#presentation")

        if not parent.hasClass(colorClass)
          parent.removeClass(@backgroundColorClasses).addClass(colorClass)

        this._removeBackgroundDiv()
    )

  _removeBackgroundDiv: () =>
    if @backgroundDiv?
      @backgroundDiv.css(opacity: 0)  # avoids flicker on the remove()
      @backgroundDiv.remove()
      @backgroundDiv = undefined

