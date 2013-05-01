
class AmoebaSite.Presentation.Slide_Home extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("homeSlide")
    @transition = 'zoom'

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      @home = new AmoebaSite.HomeScene(@el)

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      @home.tearDown()
      @home = undefined
