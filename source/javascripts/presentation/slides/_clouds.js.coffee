
class AmoebaSite.Presentation.Slide_Clouds extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("cloudsSlide")
    @transition = 'down'

  slideIn: (afterTransitionComplete) =>
    if !afterTransitionComplete
      AmoebaSite.presentation.setBackground('blue')
      this._start()

  slideOut: (afterTransitionComplete) =>
    if !afterTransitionComplete
      AmoebaSite.presentation.setBackground('default')

      # free up all these cpu hogging animations
      @controller = undefined

  _start: () =>
    @controller = new AmoebaSite.CloudsController()

