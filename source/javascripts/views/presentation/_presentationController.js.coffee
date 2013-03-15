#= require_tree ./slides

class AmoebaSite.Presentation.Controller
  constructor: () ->
    AmoebaSB.layout ?= new AmoebaSB.SlideLayout($("#stage"), $('#stageHolder'))

    this.setBackground('default')
    this._setupKeyHandlers(true)

    @slides = [
      new AmoebaSite.Presentation.Slide_Intro(),
      new AmoebaSite.Presentation.Slide_Computer(),
      new AmoebaSite.Presentation.Slide_Phone(),
      new AmoebaSite.Presentation.Slide_Team(),
      new AmoebaSite.Presentation.Slide_Cards(),
      new AmoebaSite.Presentation.Slide_Map(),
      new AmoebaSite.Presentation.Slide_Customer(),
      new AmoebaSite.Presentation.Slide_Tools(),
      new AmoebaSite.Presentation.Slide_Clouds(),
      new AmoebaSite.Presentation.Slide_PreparingYou(),
      new AmoebaSite.Presentation.Slide_Cog(),
    ]

    @transAPI = new AmoebaSB.SlideTransitions(@slides)

    @navigationControls = new AmoebaSB.NavigationControls(@slides.length)

    document.addEventListener("displayIndexEventName", (event) =>
      # force going to active step again, to trigger rescaling
      theIndex = Number(event.detail)

      @transAPI.goto(theIndex)
    )

    document.addEventListener("navigateToIndexEventName", (event) =>
      # force going to active step again, to trigger rescaling
      theIndex = Number(event.detail)

      AmoebaSite.app.homepageRouter.navigate("/presentation/#{theIndex}", {trigger: true});
    )

  tearDown: =>
    this._setupKeyHandlers(false)

  setBackground: (colorClass) =>
    allClasses = 'white black blue green, none'

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
          parent.removeClass(allClasses).addClass(colorClass)

        this._removeBackgroundDiv()
    )

  _removeBackgroundDiv: () =>
    if @backgroundDiv?
      @backgroundDiv.css(opacity: 0)  # avoids flicker on the remove()
      @backgroundDiv.remove()
      @backgroundDiv = undefined

  _next: =>
    success = this._currentSlide().next()
    if not success
      AmoebaSB.eventHelper.triggerEvent(document, "navigateToIndexEventName", @transAPI.nextIndex())

  _previous: =>
    AmoebaSB.eventHelper.triggerEvent(document, "navigateToIndexEventName", @transAPI.prevIndex())

  _currentSlide: =>
    return @slides[@transAPI.activeStepIndex]

  _setupKeyHandlers: (add) =>
    if not @prevFunction?
      @prevFunction = =>
        this._previous()

    if not @nextFunction?
      @nextFunction = =>
        this._next()

    if add
      document.addEventListener(AmoebaSB.eventHelper.prevKeyEventName, @prevFunction)
      document.addEventListener(AmoebaSB.eventHelper.nextKeyEventName, @nextFunction)
    else
      document.removeEventListener(AmoebaSB.eventHelper.prevKeyEventName, @prevFunction)
      document.removeEventListener(AmoebaSB.eventHelper.nextKeyEventName, @nextFunction)

      @nextFunction = undefined
      @prevFunction = undefined
