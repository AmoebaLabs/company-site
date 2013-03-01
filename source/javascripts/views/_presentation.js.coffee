#= require_self
#= require_directory ./homepage

class AmoebaSite.Views.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentation'

  initialize: ->

  showView: () ->
    if not AmoebaSite.presentation?
      AmoebaSite.presentation = new AmoebaSite.Presentation.Controller()

    @$el.disolveIn()

  hideView: () ->
    if AmoebaSite.presentation?
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut()














