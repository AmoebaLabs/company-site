
class AmoebaSite.Presentation.Slide_Cog extends AmoebaSB.Slide_Base
  setup: ->
    this._setupElement("cogSlide")
    @transition = 'rotate'

    bottomOffet = 10
    leftOffset = 0

    theDiv = $('<div/>')
      .text("LOGIC DRIVEN")
      .appendTo(@el)
      .css({"bottom": "#{bottomOffet}px", "left": "#{leftOffset}px", "position": "absolute", "font-size": "72px"})

  slideIn: (afterTransitionComplete) =>
    if afterTransitionComplete
      if not @cogDemo?
        @cogDemo = new AmoebaSite.Presentation.CogDemo("cogPaper", 320, 32)

      @cogDemo.start(this._cogDemoDoneCallback)

  _cogDemoDoneCallback: () =>
    this._slideIsDone(0)
    console.log 'cog demo done'

  slideOut: (afterTransitionComplete) =>
    if afterTransitionComplete
      @cogDemo.stop()

