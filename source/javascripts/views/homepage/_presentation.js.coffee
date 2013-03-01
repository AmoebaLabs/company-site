class AmoebaSite.Views.Homepage.Presentation extends Amoeba.View
  name: 'presentation'
  el: '#presentation'

  initialize: ->

  transitionIn: (from) ->
    # When from is 'none' this is an initial page load, so animate instantly
    animationTime = if from is 'none' then 0 else @parent.animationTime

    @parent.mascot.hide(animationTime)

    if not AmoebaSite.presentation?
      AmoebaSite.presentation = new AmoebaSite.Presentation.Controller()

    # Show presentation, after a delay
    @$el.css
      opacity: 0
      y: '90px'
    @$el.removeClass("hidden")
    @$el.transition
      opacity: 1
      y: '0px'
      delay: animationTime
      duration: animationTime
      easing: 'ease'

  transitionOut: (to) ->
    animationTime = @parent.animationTime

    if AmoebaSite.presentation?
      AmoebaSite.presentation = undefined

    # Hide presentation, also sets hidden class
    @$el.disolveOut(animationTime)












