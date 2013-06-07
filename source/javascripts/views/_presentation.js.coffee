#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentation'

  initialize: ->

  showView: () ->
    if not AmoebaSite.presentation?
      AmoebaSite.presentation = new AmoebaSite.SceneController(@$el)
      AmoebaSite.presentation.start()

    @$el.disolveIn(1000)

  hideView: () ->
    if AmoebaSite.presentation?
      AmoebaSite.presentation.tearDown()
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut(1000)














