#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentation'

  initialize: ->
    this._setupProgressBar()

  showView: () ->
    if not AmoebaSite.presentation?
      AmoebaSite.presentation = new AmoebaSite.SceneController(@$el)
      AmoebaSite.presentation.start()

    @$el.disolveIn(0)

  hideView: () ->
    if AmoebaSite.presentation?
      AmoebaSite.presentation.tearDown()
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut(0)

  _setupProgressBar: () =>
    @progressIndex = 0
    @progressSteps = 6

     # progress bar at bottom
    $('<div/>')
      .appendTo(@el)
      .attr({id: "progressBar"})
      .html('<span></span>')
      .click( (event) =>
        console.log 'clicked progress bar'
      )

    # listen for events to increment progress
    $('body').on('amoeba:incrementProgressBar', =>
      @progressIndex++

      ratio = @progressIndex / (@progressSteps - 1)

      $("#progressBar span").css(width: "#{ratio * window.innerWidth}px")
    )






