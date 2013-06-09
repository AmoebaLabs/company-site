#= require_tree ./scenes

class AmoebaSite.SceneController
  constructor: (@el) ->
    AmoebaSB.layout ?= new AmoebaSB.SlideLayout($("#stage"), $('#stageHolder'))
    @backgroundColorClasses = 'white black blue green none'

  start: =>
    this._runSequence()

  tearDown: =>
    @cube?.tearDown()
    @cube = undefined

    @toolsScene?.tearDown()
    @toolsScene = undefined

    @cloudScene?.tearDown()
    @cloudScene = undefined

  _runSequence: () =>
    contentDiv = @el.find('#content')

    @cube = new AmoebaSite.CubeScene(contentDiv, =>
      @cube.tearDown()
      @cube = undefined

      @toolsScene = new AmoebaSite.ToolsScene(contentDiv, =>
        @toolsScene.tearDown()
        @toolsScene = undefined

        @cloudScene = new AmoebaSite.CloudScene(contentDiv, =>
          # keep the clouds on for a few seconds
          setTimeout(=>
            this._sequenceDone()
          , 1000)
        )
      )

      @toolsScene.start()
    )

  _sequenceDone: =>
    # old shit, throw away if not used
    #          @cloudScene.tearDown()
    #          @cloudScene = undefined
    #          AmoebaSite.presentation.setBackground('black')
    #          AmoebaSite.utils.hideDiv(@mascot, true)

    $("body").trigger("switchToPresentation", [false])

  setBackgroundColor: (color) =>
    this._setPresentationBackgroundColor(color)

  setBackground: (colorClass) =>
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
      duration: AmoebaSite.utils.dur(2000)
      complete: =>
        this._setPresentationBackgroundColor(undefined, colorClass)

        this._removeBackgroundDiv()
    )

  _removeBackgroundDiv: =>
    if @backgroundDiv?
      theDiv = @backgroundDiv
      @backgroundDiv = undefined

      theDiv.transition(
        opacity: 0
        duration: 100  # just trying to avoid flicker, time doesn't matter
        complete: =>
          theDiv.remove()
      )

  _setPresentationBackgroundColor: (backgroundColor, backgroundClass) =>
    theDiv = $("#presentation")

    if backgroundClass == 'default'
      backgroundClass = 'none'

    if backgroundColor?
      theDiv.css(
        backgroundColor: backgroundColor
      )

      theDiv.removeClass(@backgroundColorClasses)

    else if backgroundClass?
      if not theDiv.hasClass(backgroundClass)
        theDiv.removeClass(@backgroundColorClasses)
        theDiv.addClass(backgroundClass)

      theDiv.css(
        backgroundColor: '' # clear the color
      )


