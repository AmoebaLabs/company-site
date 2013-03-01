#= require_tree ./slides

class Amoeba.Presentation.Controller
  constructor: () ->
    AmoebaSB.layout ?= new AmoebaSB.SlideLayout($("#stage"), $('#stageHolder'))

    this.setBackground('default')
    this._setupKeyHandler()

    @slides = [
      new Amoeba.Presentation.Slide_Intro(),
      new Amoeba.Presentation.Slide_Computer(),
      new Amoeba.Presentation.Slide_Phone(),
      new Amoeba.Presentation.Slide_Cards(),
      new Amoeba.Presentation.Slide_Map(),
      new Amoeba.Presentation.Slide_Tools(),
      new Amoeba.Presentation.Slide_Clouds(),
      new Amoeba.Presentation.Slide_Cog(),
      new Amoeba.Presentation.Slide_Cube()
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

    # KKK SNG
  showPresentation: (hide=false) =>
#    if hide
#      $("#presentation").addClass("hidden")
#    else
#      $("#presentation").removeClass("hidden")
#

  setBackground: (colorClass) =>
    if colorClass == 'default'
      colorClass = 'green'

    background = $('#presentationBackground')

    if not background.hasClass(colorClass)
      background.removeClass('white black blue green')
      background.addClass(colorClass)

  _next: =>
    success = this._currentSlide().next()
    if not success
      AmoebaSB.eventHelper.triggerEvent(document, "navigateToIndexEventName", @transAPI.nextIndex())

  _previous: =>
    AmoebaSB.eventHelper.triggerEvent(document, "navigateToIndexEventName", @transAPI.prevIndex())

  _currentSlide: =>
    return @slides[@transAPI.activeStepIndex]

  _setupKeyHandler: =>
    document.addEventListener(AmoebaSB.eventHelper.prevKeyEventName, (event) =>
      # only send key events if presentation is current
      # KKK SNG if Amoeba.homepageView.presentationIsCurrent()
      this._previous();
    )

    document.addEventListener(AmoebaSB.eventHelper.nextKeyEventName, (event) =>
      # only send key events if presentation is current
      # KKK SNG if Amoeba.homepageView.presentationIsCurrent()
      this._next();
    )
