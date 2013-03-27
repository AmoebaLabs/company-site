
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
    else
      @controller.tearDown()
      @controller = undefined

  _start: () =>
    setTimeout(=>
      @controller = new AmoebaSite.CloudsController(@el, this._cloudControllerCallback)
    , 300)

  # called when cloud controller finishes it's animation sequence
  _cloudControllerCallback: () =>
    this._slideIsDone(1000)

